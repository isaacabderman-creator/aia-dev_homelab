# Run by settle-deploy.service as root (see settle-deploy.nix). USER_NAME, USER_HOME and FLAKE
# come from the unit. Building happens as the user; root only activates the finished system.

state=/var/lib/settle-deploy
as_user() { runuser -u "$USER_NAME" -- env HOME="$USER_HOME" "$@"; }
ssh_for() { echo "ssh -i $USER_HOME/.ssh/$1 -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=yes"; }
nix_() { as_user nix --extra-experimental-features "nix-command flakes" "$@"; }

# repo name -> its read-only deploy key (GitHub needs one key per repo)
declare -A keys=([settle-backend]=settle_deploy [settle-ai]=settle_ai_deploy)
declare -A before after
updated=()

for repo in "${!keys[@]}"; do
	url="git@github.com:isaacabderman-creator/$repo.git"
	git_ssh=$(ssh_for "${keys[$repo]}")
	remote=$(as_user env GIT_SSH_COMMAND="$git_ssh" git ls-remote "$url" refs/heads/release | cut -f1)
	if [ -z "$remote" ]; then
		echo "$repo: no release branch yet"
		continue
	fi
	current=$(as_user git -C "$USER_HOME/$repo.git" rev-parse refs/heads/main)
	[ "$remote" != "$current" ] || continue
	if [ "$(cat "$state/$repo.failed" 2>/dev/null || true)" = "$remote" ]; then
		continue # this commit already failed; wait for a newer one
	fi
	as_user env GIT_SSH_COMMAND="$git_ssh" git -C "$USER_HOME/$repo.git" fetch --quiet "$url" "+refs/heads/release:refs/heads/main"
	before[$repo]=$current
	after[$repo]=$remote
	updated+=("$repo")
done

[ "${#updated[@]}" -gt 0 ] || exit 0
echo "deploying: ${updated[*]}"

cp "$FLAKE/flake.lock" "$state/flake.lock.previous"

# Puts the sources back as they were and remembers the commits that failed
undo_sources() {
	for repo in "${updated[@]}"; do
		as_user git -C "$USER_HOME/$repo.git" update-ref refs/heads/main "${before[$repo]}"
		echo "${after[$repo]}" >"$state/$repo.failed"
	done
	as_user cp "$state/flake.lock.previous" "$FLAKE/flake.lock"
}

if ! nix_ flake update "${updated[@]}" --flake "$FLAKE" ||
	! system=$(nix_ build --no-link --print-out-paths "$FLAKE#nixosConfigurations.nixos.config.system.build.toplevel"); then
	echo "build failed: the running system is unchanged"
	undo_sources
	exit 1
fi

nix-env -p /nix/var/nix/profiles/system --set "$system"
"$system/bin/switch-to-configuration" switch || echo "activation reported errors; checking the services"

for _ in $(seq 1 24); do
	if curl -fsS -m 3 http://127.0.0.1:8080/healthz >/dev/null && curl -fsS -m 3 http://127.0.0.1:8090/health >/dev/null; then
		for repo in "${updated[@]}"; do
			echo "deployed $repo ${after[$repo]:0:7}"
			rm -f "$state/$repo.failed"
		done
		exit 0
	fi
	sleep 5
done

echo "health check failed: rolling back"
nix-env -p /nix/var/nix/profiles/system --rollback
/nix/var/nix/profiles/system/bin/switch-to-configuration switch || true
undo_sources
exit 1
