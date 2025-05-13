# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains dotfiles for configuring development environments across different operating systems (macOS, Ubuntu, and Windows). It uses GNU Stow to manage symlinks for various tool configurations including:

- Neovim
- Zsh
- Git
- Kitty terminal
- Yabai (window manager for macOS)
- Tmux
- Lazygit
- Spotify-tui and Spotifyd

## Setup Commands

### Installation

For macOS:
```bash
git clone https://github.com/haydenmeade/dotfiles && cd dotfiles && ./macos
```

For Ubuntu:
```bash
git clone https://github.com/haydenmeade/dotfiles && cd dotfiles && ./ubuntu
```

### Neovim Installation

```bash
bash ./scripts/installnvimfromrelease.sh
```

Alternative installation methods:
- macOS: `brew install --HEAD neovim`
- Ubuntu: 
  ```bash
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt update
  sudo apt install neovim -y
  ```
- Windows: 
  ```
  scoop bucket add versions
  scoop install neovim-nightly
  ```

## Development Workflow

### Neovim

The Neovim configuration uses lazy.nvim as a plugin manager. Common operations:

- Plugin management: 
  - `:Lazy`: Open plugin management interface
  - `:Lazy sync`: Update and install all plugins

- LSP Setup:
  - The repository uses Neovim's native LSP client
  - LSP servers are enabled in `nvim/.config/nvim/lua/lsp/init.lua`
  - Keymappings are defined in `nvim/.config/nvim/lua/config/lsp_keymap.lua`

- Formatting:
  - Uses conform.nvim for formatting
  - Configured formatters in `plugins.lua`

### Testing

For Go testing:
- `<leader>tn`: Run test at current line
- `<leader>tf`: Run test file
- `<leader>ts`: Toggle test result window
- `<leader>tp`: Run previous test

## Environment Management

The dotfiles repository uses stow to manage symlinks. The installation scripts (`macos` and `ubuntu`) set the `STOW_FOLDERS` environment variable to specify which folders to symlink.

To apply changes to stow configurations:
```bash
./install  # Re-applies all stow configurations
```

## Dependencies

Core dependencies:
- git
- zsh
- stow
- curl
- wget
- gzip
- lazygit
- fzf
- python3

Language-specific dependencies are installed through scripts or package managers:
- Node.js (via nvm)
- Go
- Rust
- Ruby