#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TOKEN_FILE="$ROOT_DIR/nix-config/github_token"

if [[ ! -f "$TOKEN_FILE" ]]; then
  echo "❌ github_token not found at $TOKEN_FILE"
  exit 1
fi

TOKEN="$(tr -d '\n' < "$TOKEN_FILE")"

if [[ -z "$TOKEN" ]]; then
  echo "❌ github_token is empty"
  exit 1
fi

echo "🔐 Installing GitHub token into /etc/nix/nix.conf"

sudo mkdir -p /etc/nix

sudo sed -i.bak '/^access-tokens *=/d' /etc/nix/nix.conf 2>/dev/null || true
echo "access-tokens = github.com=$TOKEN" | sudo tee -a /etc/nix/nix.conf > /dev/null

echo "🔎 Verifying…"

if sudo nix config show | grep -q "github.com="; then
  echo "✅ GitHub token installed and active"
else
  echo "❌ Token not detected by nix"
  exit 1
fi

