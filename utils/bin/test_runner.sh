#!/usr/bin/env bash
set -e

export UFOVIM_CONFIG_DIR="${UFOVIM_CONFIG_DIR:-"$HOME/.config/ufovim"}"
export UFOVIM_RUNTIME_DIR="${UFOVIM_RUNTIME_DIR:-"$HOME/.local/share/ufovim"}"

export UFOVIM_TEST_ENV=true

rm -f "$UFOVIM_CONFIG_DIR/plugin/packer_compiled.lua"

ufovim() {
  # TODO: allow running with a minimal_init.lua
  nvim -u "$UFOVIM_RUNTIME_DIR/ufovim/tests/minimal_init.lua" --cmd "set runtimepath+=$UFOVIM_RUNTIME_DIR/ufovim" "$@"
}

if [ -n "$1" ]; then
  ufovim --headless -c "lua require('plenary.busted').run('$1')"
else
  ufovim --headless -c "PlenaryBustedDirectory tests/ { minimal_init = './tests/minimal_init.lua' }"
fi
