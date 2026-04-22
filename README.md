![Build Status](https://github.com/isaacabderman-creator/aia-dev_homelab/actions/workflows/format.yml/badge.svg)
# AIA DEV HOMELAB

A NixOS config for my homeserver using Home Manager

## Features

- Static IP address
- System suspension & sleep disabled
- Ad filtering using AdGuard Home (accessible at [dns.aialab.tech](https://dns.aialab.tech))
- Parallel DNS requests + caching via Quad9 & Cloudflare upstreams
- Cloudflare Tunnel — all public traffic proxied through Cloudflare, no ports exposed to the internet
- SSH hardening — key-only auth, root login disabled
- Modular Nix flake structure (`hosts/`, `modules/`, `home/`) with Home Manager integrated as a NixOS module
