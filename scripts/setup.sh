#!/usr/bin/env bash
set -eo pipefail

declare -r INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"

declare -r XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
declare -r XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
declare -r XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

declare -r NVIM_RUNTIME_DIR="${NVIM_RUNTIME_DIR:-"$XDG_DATA_HOME/nvim"}"
declare -r NVIM_CONFIG_DIR="${NVIM_CONFIG_DIR:-"$XDG_CONFIG_HOME/nvim"}"
declare -r NVIM_BASE_DIR="${NVIM_BASE_DIR:-"$NVIM_RUNTIME_DIR/nvim"}"

declare -r NVIM_CACHE_DIR="$XDG_CACHE_HOME/nvim"

declare BASEDIR
BASEDIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BASEDIR="$(dirname -- "$(dirname -- "$BASEDIR")")"
readonly BASEDIR

declare ARGS_INSTALL_DEPENDENCIES=0
declare ARGS_INSTALL_LSP=0

declare -a __npm_deps=(
  "neovim"
  "tree-sitter-cli"
  "@fsouza/prettierd"
  "jsonls"
)

declare __lsp_deps="gopls pyright bashls clangd jsonls solargraph sumneko_lua tsserver"

declare -a __pip_deps=(
  "pynvim"
  "flake8"
)

declare -a ___rust_deps=(
  "fd::fd-find"
  "rg::ripgrep"
)

function usage() {
  echo "Usage: install.sh [<options>]"
  echo ""
  echo "Options:"
  echo "    -h, --help                               Print this help message"
  echo "    --[no]-install-dependencies              Whether to automatically install external dependencies (will prompt by default)"
  echo "    --install-lsp                            Whether to automatically install lsp servers"
}

function parse_arguments() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --install-dependencies)
        ARGS_INSTALL_DEPENDENCIES=1
        ;;
      --no-install-dependencies)
        ARGS_INSTALL_DEPENDENCIES=0
        ;;
      --install-lsp)
        ARGS_INSTALL_LSP=1
        ;;
      --clear-cache)
        ARGS_CLEAR_CACHE=1
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

  # mkdir -p ~/.config/nvim
  # stow -v nvim -t ~/.config/nvim

  if [ "$ARGS_INSTALL_DEPENDENCIES" -eq 1 ]; then
    detect_platform
    check_system_deps
    install_nodejs_deps
    install_python_deps
    install_rust_deps
  fi

  link_repo
  # setup_nvim
  echo "Do not forget to use a font with glyphs (icons) support [https://github.com/ryanoasis/nerd-fonts]"
}

function link_repo() {
  echo "Linking local repo"

  # Detect whether it's a symlink or a folder
  if [ -d "$NVIM_BASE_DIR" ]; then
    echo "Removing old installation files"
    rm -rf "$NVIM_BASE_DIR"
  fi

  echo "   - $BASEDIR -> $NVIM_BASE_DIR"
  ln -s -f "$BASEDIR" "$NVIM_BASE_DIR"
}

function remove_old_cache_files() {
  local packer_cache="$NVIM_CONFIG_DIR/plugin/packer_compiled.lua"
  if [ -e "$packer_cache" ]; then
    msg "Removing old packer cache file"
    rm -f "$packer_cache"
  fi

  if [ -e "$NVIM_CACHE_DIR/luacache" ] || [ -e "$NVIM_CACHE_DIR/nvim_cache" ]; then
    msg "Removing old startup cache file"
    rm -f "$NVIM_CACHE_DIR/{luacache,nvim_cache}"
  fi
}

function setup_nvim() {

  remove_old_cache_files

  echo "Preparing Packer setup"

  "nvim" --headless \
    -c 'autocmd User PackerComplete quitall' \
    -c 'PackerSync'

  if [[ "$ARGS_INSTALL_LSP" -eq 1 ]]; then
    "nvim" --headless \
      -c "LspInstall --sync ${__lsp_deps}"  -c q
  fi

  echo "Packer setup complete"
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

function __install_nodejs_deps_pnpm() {
  echo "Installing node modules with pnpm.."
  pnpm install -g "${__npm_deps[@]}"
  echo "All NodeJS dependencies are successfully installed"
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

function __validate_node_installation() {
  local pkg_manager="$1"
  local manager_home

  if ! command -v "$pkg_manager" &>/dev/null; then
    return 1
  fi

  if [ "$pkg_manager" == "npm" ]; then
    manager_home="$(npm config get prefix 2>/dev/null)"
  elif [ "$pkg_manager" == "pnpm" ]; then
    manager_home="$(pnpm config get prefix 2>/dev/null)"
  else
    manager_home="$(yarn global bin 2>/dev/null)"
  fi

  if [ ! -d "$manager_home" ] || [ ! -w "$manager_home" ]; then
    echo "[ERROR] Unable to install using [$pkg_manager] without administrative privileges."
    return 1
  fi

  return 0
}

function install_nodejs_deps() {
  local -a pkg_managers=("pnpm" "yarn" "npm")
  for pkg_manager in "${pkg_managers[@]}"; do
    if __validate_node_installation "$pkg_manager"; then
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
  for dep in "${___rust_deps[@]}"; do
    if ! command -v "${dep%%::*}" &>/dev/null; then
      __attempt_to_install_with_cargo "${dep##*::}"
    fi
  done
  echo "All Rust dependencies are successfully installed"
}

function check_neovim_min_version() {
  local verify_version_cmd='if !has("nvim-0.7") | cquit | else | quit | endif'

  # exit with an error if min_version not found
  if ! nvim --headless -u NONE -c "$verify_version_cmd"; then
    echo "[ERROR]: requires at least Neovim v0.7 or higher"
    exit 1
  fi
}

function check_system_deps() {
  if which git >/dev/null; then
    print_missing_dep_msg "git"
    exit 1
  fi
  if which nvim >/dev/null; then
    print_missing_dep_msg "neovim"
    exit 1
  fi
  check_neovim_min_version
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
    FreeBSD)
      RECOMMEND_INSTALL="sudo pkg install -y"
      ;;
    NetBSD)
      RECOMMEND_INSTALL="sudo pkgin install"
      ;;
    OpenBSD)
      RECOMMEND_INSTALL="doas pkg_add"
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

main "$@"
