#!/usr/bin/env bash
set -euo pipefail

# Move to this script’s directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Use Node 18.19.0 via nvm (install if missing)
if command -v nvm >/dev/null 2>&1; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 18.19.0
  nvm use 18.19.0
  echo "Using Node $(node --version)"
else
  echo "⚠️  nvm not found—make sure Node v18.19.0 is installed"
fi

# Clean & reinstall
echo "🧹 Cleaning previous installs..."
rm -rf node_modules package-lock.json

echo "📦 Installing deps (legacy peer-deps)..."
npm install --legacy-peer-deps

# Launch server
echo "🚀 Starting Angular Dev Server on port 4200..."
npx ng serve --port 4200
