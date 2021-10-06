#!/usr/bin/env bash
set -eo pipefail

declare -r INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"

declare -r XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
declare -r XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
declare -r XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

declare -r UFOVIM_RUNTIME_DIR="${UFOVIM_RUNTIME_DIR:-"$XDG_DATA_HOME/ufovim"}"
declare -r UFOVIM_CONFIG_DIR="${UFOVIM_CONFIG_DIR:-"$XDG_CONFIG_HOME/ufovim"}"

# TODO: Use a dedicated cache directory #1256
declare -r UFOVIM_CACHE_DIR="$XDG_CACHE_HOME/nvim"

function setup_shim() {
  if [ ! -d "$INSTALL_PREFIX/bin" ]; then
    mkdir -p "$INSTALL_PREFIX/bin"
  fi
  cat >"$INSTALL_PREFIX/bin/ufovim" <<EOF
#!/bin/sh

export UFOVIM_CONFIG_DIR="\${UFOVIM_CONFIG_DIR:-$UFOVIM_CONFIG_DIR}"
export UFOVIM_RUNTIME_DIR="\${UFOVIM_RUNTIME_DIR:-$UFOVIM_RUNTIME_DIR}"
export UFOVIM_CACHE_DIR="\${UFOVIM_CACHE_DIR:-$UFOVIM_CACHE_DIR}"

exec nvim -u "\$UFOVIM_RUNTIME_DIR/ufovim/init.lua" "\$@"
EOF
  chmod +x "$INSTALL_PREFIX/bin/ufovim"
}

setup_shim "$@"
echo "You can start ufovim by running: $INSTALL_PREFIX/bin/ufovim"
