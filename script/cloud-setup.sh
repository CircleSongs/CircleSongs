#!/usr/bin/env bash
# Setup script for Claude Code on the web. Paste it (or load it with "Choose
# file") in the cloud environment's Setup script field. The environment's
# network access must allow rubygems.org and the mise/Ruby download hosts.
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v mise >/dev/null 2>&1; then
  curl -fsSL https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

# Exact Ruby and Node versions come from .tool-versions.
mise install --yes
eval "$(mise activate bash)"

gem install bundler --conservative
bundle install
yarn install --frozen-lockfile
