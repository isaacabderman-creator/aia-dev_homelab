{ config, ... }:

{
  # Settle API (module from the settle-backend flake input), published as api.aialab.tech.
  services.settle-api = {
    enable = true;
    port = 8080;
    corsOrigins = [
      "https://localhost" # Capacitor Android
      "http://localhost:5173" # SvelteKit dev server on the laptop
      "https://settle.aialab.tech" # the web app (custom domain on Vercel; same site as the API, for the session cookie)
      "https://settle-frontend-hazel.vercel.app" # Vercel default address
    ];
    # The assistant: the API calls settle-ai on localhost with the shared token
    ai = {
      url = "http://127.0.0.1:${toString config.services.settle-ai.port}";
      tokenFile = config.services.settle-ai.internalTokenFile;
    };
  };
  systemd.services.settle-api = {
    after = [ "settle-ai-token.service" ];
    requires = [ "settle-ai-token.service" ];
  };

  # Settle AI (module from the settle-ai flake input): 127.0.0.1 only, never published.
  # The Gemini key is a root-only file: /etc/settle/gemini-api-key
  services.settle-ai = {
    enable = true;
    port = 8090;
  };
}
