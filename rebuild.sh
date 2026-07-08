#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
# --impure lets the config read the live filesystem (e.g. detecting whether
# this macOS release ships Launchpad.app vs the Tahoe "Apps" launcher).
exec sudo darwin-rebuild switch --flake ~/.dotfiles#mac --impure
