![Build Status](https://github.com/isaacabderman-creator/aia-dev_homelab/actions/workflows/format.yml/badge.svg)
# AIA DEV HOMELAB

A NixOS config for my homeserver using Home Manager

## Release

**v0.1.0** — initial stable baseline for the homelab. The setup is functional, reproducible, and hardened enough to use as a starting point for future changes.

## Features

- Static IP address on `enp3s0`
- System suspension & sleep disabled
- AdGuard Home on `127.0.0.1:3000`, exposed through Cloudflare Tunnel at [adguard.aialab.tech](https://adguard.aialab.tech)
- Parallel DNS requests + caching via Quad9 & Cloudflare upstreams
- Tailscale for trusted private network access
- SSH hardening and Fail2ban protection
- Weekly automatic system upgrades
- Modular Nix flake structure (`hosts/`, `modules/`, `home/`) with Home Manager integrated as a NixOS module
