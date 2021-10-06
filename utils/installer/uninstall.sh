#!/bin/sh
USER_BIN_DIR="$HOME/.local/bin"
if [ -d "/data/data/com.termux" ]; then
  sudo() {
    eval "$@"
  }
  USER_BIN_DIR="$HOME/../usr/bin"
fi
rm -rf ~/.local/share/ufovim
sudo rm "$USER_BIN_DIR"/ufovim
rm -rf ~/.local/share/applications/ufovim.desktop
