#!/usr/bin/env bash
set -eo pipefail

#Set branch to master unless specified by the user
declare LV_BRANCH="${LV_BRANCH:-"rolling"}"
declare -r LV_REMOTE="${LV_REMOTE:-taurusomar/ufovim.git}"
declare -r INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"

declare -r XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
declare -r XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
declare -r XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

declare -r UFOVIM_RUNTIME_DIR="${UFOVIM_RUNTIME_DIR:-"$XDG_DATA_HOME/ufovim"}"
declare -r UFOVIM_CONFIG_DIR="${UFOVIM_CONFIG_DIR:-"$XDG_CONFIG_HOME/ufovim"}"
# TODO: Use a dedicated cache directory #1256
declare -r UFOVIM_CACHE_DIR="$XDG_CACHE_HOME/nvim"
declare -r UFOVIM_PACK_DIR="$UFOVIM_RUNTIME_DIR/site/pack"

declare BASEDIR
BASEDIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BASEDIR="$(dirname -- "$(dirname -- "$BASEDIR")")"
readonly BASEDIR

declare ARGS_LOCAL=0
declare ARGS_OVERWRITE=0
declare ARGS_INSTALL_DEPENDENCIES=1

declare -a __ufovim_dirs=(
  "$UFOVIM_CONFIG_DIR"
  "$UFOVIM_RUNTIME_DIR"
  "$UFOVIM_CACHE_DIR"
)

declare -a __npm_deps=(
  "neovim"
  "tree-sitter-cli"
)

declare -a __pip_deps=(
  "pynvim"
)

function usage() {
  echo "Usage: install.sh [<options>]"
  echo ""
  echo "Options:"
  echo "    -h, --help                       Print this help message"
  echo "    -l, --local                      Install local copy of UfoVim"
  echo "    --overwrite                      Overwrite previous UfoVim configuration (a backup is always performed first)"
  echo "    --[no]-install-dependencies      Whether to prompt to install external dependencies (will prompt by default)"
}

function parse_arguments() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      -l | --local)
        ARGS_LOCAL=1
        ;;
      --overwrite)
        ARGS_OVERWRITE=1
        ;;
      --install-dependencies)
        ARGS_INSTALL_DEPENDENCIES=1
        ;;
      --no-install-dependencies)
        ARGS_INSTALL_DEPENDENCIES=0
        ;;
      -h | --help)
        usage
        exit 0
        ;;
    esac
    shift
  done
}

function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

function main() {
  parse_arguments "$@"

  print_logo

  msg "Detecting platform for managing any additional neovim dependencies"
  detect_platform

  check_system_deps

  if [ "$ARGS_INSTALL_DEPENDENCIES" -eq 1 ]; then
    msg "Would you like to install UfoVim's NodeJS dependencies?"
    read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] && install_nodejs_deps

    msg "Would you like to install UfoVim's Python dependencies?"
    read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] && install_python_deps

    msg "Would you like to install UfoVim's Rust dependencies?"
    read -p "[y]es or [n]o (default: no) : " -r answer
    [ "$answer" != "${answer#[Yy]}" ] && install_rust_deps
  fi

  msg "Backing up old UfoVim configuration"
  backup_old_config

  if [ "$ARGS_OVERWRITE" -eq 1 ]; then
    for dir in "${__ufovim_dirs[@]}"; do
      [ -d "$dir" ] && rm -rf "$dir"
    done
  fi

  install_packer

  if [ -e "$UFOVIM_RUNTIME_DIR/ufovim/init.lua" ]; then
    update_ufovim
  else
    if [ "$ARGS_LOCAL" -eq 1 ]; then
      link_local_ufovim
    else
      clone_ufovim
    fi
    setup_ufovim
  fi

  msg "Thank you for installing UfoVim!!"
  echo "You can start it by running: $INSTALL_PREFIX/bin/ufovim"
  echo "Do not forget to use a font with glyphs (icons) support [https://github.com/ryanoasis/nerd-fonts]"
}

function detect_platform() {
  OS="$(uname -s)"
  case "$OS" in
    Linux)
      if [ -f "/etc/arch-release" ] || [ -f "/etc/artix-release" ]; then
        RECOMMEND_INSTALL="sudo pacman -S"
      elif [ -f "/etc/fedora-release" ] || [ -f "/etc/redhat-release" ]; then
        RECOMMEND_INSTALL="sudo dnf install -y"
      elif [ -f "/etc/gentoo-release" ]; then
        RECOMMEND_INSTALL="emerge install -y"
      else # assume debian based
        RECOMMEND_INSTALL="sudo apt install -y"
      fi
      ;;
    Darwin)
      RECOMMEND_INSTALL="brew install"
      ;;
    *)
      echo "OS $OS is not currently supported."
      exit 1
      ;;
  esac
}

function print_missing_dep_msg() {
  if [ "$#" -eq 1 ]; then
    echo "[ERROR]: Unable to find dependency [$1]"
    echo "Please install it first and re-run the installer. Try: $RECOMMEND_INSTALL $1"
  else
    local cmds
    cmds=$(for i in "$@"; do echo "$RECOMMEND_INSTALL $i"; done)
    printf "[ERROR]: Unable to find dependencies [%s]" "$@"
    printf "Please install any one of the dependencies and re-run the installer. Try: \n%s\n" "$cmds"
  fi
}

function check_system_deps() {
  if ! command -v git &>/dev/null; then
    print_missing_dep_msg "git"
    exit 1
  fi
  if ! command -v nvim &>/dev/null; then
    print_missing_dep_msg "neovim"
    exit 1
  fi
}

function __install_nodejs_deps_npm() {
  echo "Installing node modules with npm.."
  for dep in "${__npm_deps[@]}"; do
    if ! npm ls -g "$dep" &>/dev/null; then
      printf "installing %s .." "$dep"
      npm install -g "$dep"
    fi
  done
  echo "All NodeJS dependencies are successfully installed"
}

function __install_nodejs_deps_yarn() {
  echo "Installing node modules with yarn.."
  yarn global add "${__npm_deps[@]}"
  echo "All NodeJS dependencies are successfully installed"
}

function install_nodejs_deps() {
  local -a pkg_managers=("yarn" "npm")
  for pkg_manager in "${pkg_managers[@]}"; do
    if command -v "$pkg_manager" &>/dev/null; then
      eval "__install_nodejs_deps_$pkg_manager"
      return
    fi
  done
  print_missing_dep_msg "${pkg_managers[@]}"
  exit 1
}

function install_python_deps() {
  echo "Verifying that pip is available.."
  if ! python3 -m ensurepip &>/dev/null; then
    if ! python3 -m pip --version &>/dev/null; then
      print_missing_dep_msg "pip"
      exit 1
    fi
  fi
  echo "Installing with pip.."
  for dep in "${__pip_deps[@]}"; do
    python3 -m pip install --user "$dep"
  done
  echo "All Python dependencies are successfully installed"
}

function __attempt_to_install_with_cargo() {
  if command -v cargo &>/dev/null; then
    echo "Installing missing Rust dependency with cargo"
    cargo install "$1"
  else
    echo "[WARN]: Unable to find cargo. Make sure to install it to avoid any problems"
    exit 1
  fi
}

# we try to install the missing one with cargo even though it's unlikely to be found
function install_rust_deps() {
  local -a deps=("fd::fd-find" "rg::ripgrep")
  for dep in "${deps[@]}"; do
    if ! command -v "${dep%%::*}" &>/dev/null; then
      __attempt_to_install_with_cargo "${dep##*::}"
    fi
  done
  echo "All Rust dependencies are successfully installed"
}

function backup_old_config() {
  for dir in "${__ufovim_dirs[@]}"; do
    # we create an empty folder for subsequent commands \
    # that require an existing directory
    mkdir -p "$dir" "$dir.bak"
    touch "$dir/ignore"
    if command -v rsync &>/dev/null; then
      rsync --archive -hh --partial --progress --cvs-exclude \
        --modify-window=1 "$dir"/ "$dir.bak"
    else
      OS="$(uname -s)"
      case "$OS" in
        Linux)
          cp -r "$dir/"* "$dir.bak/."
          ;;
        Darwin)
          cp -R "$dir/"* "$dir.bak/."
          ;;
        *)
          echo "OS $OS is not currently supported."
          ;;
      esac
    fi
  done
  echo "Backup operation complete"
}

function install_packer() {
  if [ -e "$UFOVIM_PACK_DIR/packer/start/packer.nvim" ]; then
    msg "Packer already installed"
  else
    if ! git clone --depth 1 "https://github.com/wbthomason/packer.nvim" \
      "$UFOVIM_PACK_DIR/packer/start/packer.nvim"; then
      msg "Failed to clone Packer. Installation failed."
      exit 1
    fi
  fi
}

function clone_ufovim() {
  msg "Cloning UfoVim configuration"
  if ! git clone --branch "$LV_BRANCH" \
    --depth 1 "https://github.com/${LV_REMOTE}" "$UFOVIM_RUNTIME_DIR/ufovim"; then
    echo "Failed to clone repository. Installation failed."
    exit 1
  fi
}

function link_local_ufovim() {
  echo "Linking local UfoVim repo"

  # Detect whether it's a symlink or a folder
  if [ -d "$UFOVIM_RUNTIME_DIR/ufovim" ]; then
    echo "Removing old installation files"
    rm -rf "$UFOVIM_RUNTIME_DIR/ufovim"
  fi

  mkdir -p "$UFOVIM_RUNTIME_DIR"
  echo "   - $BASEDIR -> $UFOVIM_RUNTIME_DIR/ufovim"
  ln -s -f "$BASEDIR" "$UFOVIM_RUNTIME_DIR/ufovim"
}

function setup_shim() {
  if [ ! -d "$INSTALL_PREFIX/bin" ]; then
    mkdir -p "$INSTALL_PREFIX/bin"
  fi
  cat >"$INSTALL_PREFIX/bin/ufovim" <<EOF
#!/bin/sh

export UFOVIM_CONFIG_DIR="\${UFOVIM_CONFIG_DIR:-$UFOVIM_CONFIG_DIR}"
export UFOVIM_RUNTIME_DIR="\${UFOVIM_RUNTIME_DIR:-$UFOVIM_RUNTIME_DIR}"

exec nvim -u "\$UFOVIM_RUNTIME_DIR/ufovim/init.lua" "\$@"
EOF
  chmod +x "$INSTALL_PREFIX/bin/ufovim"
}

function remove_old_cache_files() {
  local packer_cache="$UFOVIM_CONFIG_DIR/plugin/packer_compiled.lua"
  if [ -e "$packer_cache" ]; then
    msg "Removing old packer cache file"
    rm -f "$packer_cache"
  fi

  if [ -e "$UFOVIM_CACHE_DIR/luacache" ] || [ -e "$UFOVIM_CACHE_DIR/ufovim_cache" ]; then
    msg "Removing old startup cache file"
    rm -f "$UFOVIM_CACHE_DIR/{luacache,ufovim_cache}"
  fi
}

function setup_ufovim() {

  remove_old_cache_files

  msg "Installing UfoVim shim"

  setup_shim

  echo "Preparing Packer setup"

  cp "$UFOVIM_RUNTIME_DIR/ufovim/utils/installer/config.example-no-ts.lua" \
    "$UFOVIM_CONFIG_DIR/config.lua"

  "$INSTALL_PREFIX/bin/ufovim" --headless \
    -c 'autocmd User PackerComplete quitall' \
    -c 'PackerSync'

  echo "Packer setup complete"

  cp "$UFOVIM_RUNTIME_DIR/ufovim/utils/installer/config.example.lua" "$UFOVIM_CONFIG_DIR/config.lua"
}

function update_ufovim() {
  "$INSTALL_PREFIX/bin/ufovim" --headless +'UfovimUpdate' +q
}

function print_logo() {
  cat <<'EOF'
        __            _           
 /\ /\ / _| ___/\   /(_)_ __ ___  
/ / \ \ |_ / _ \ \ / / | '_ ` _ \ 
\ \_/ /  _| (_) \ V /| | | | | | |
 \___/|_|  \___/ \_/ |_|_| |_| |_|
                                  

EOF
}

main "$@"
