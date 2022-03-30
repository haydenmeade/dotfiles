# dotfiles

to check out:
andythigpen / nvim-coverage
b0o / SchemaStore.nvim

# to add to setup:

go install mvdan.cc/gofumpt@latest
go install github.com/mgechev/revive@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
sudo apt install shellcheck
sudo apt-get install jq -- json for snapshot

Setup:
install nvim:
bash ./installnvimfromrelease.sh
or
#linux:
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt install neovim -y

bash ./setup.sh --[no]-install-dependencies

#Dependencies:

fd
neovim
python3
fzf
ripgrep
tree
git
wget
aria2

lsp:
python
pyright
https://github.com/pyenv/pyenv

go --https://github.com/canha/golang-tools-install-script
goenv?
gopls

lua
sumneko_lua
stylua

typescript
tsserver
eslint_d
node version manager
https://github.com/nvm-sh/nvm

ruby
*brew install rbenv ruby-build
*sudo apt install rbenv ruby-build
solargraph \*https://gorails.com/setup/windows/10
https://github.com/rbenv/rbenv
https://github.com/rbenv/ruby-build
\*curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash

C/C++
clangd

#Windows(WSL):
Font: https://github.com/wclr/my-nerd-fonts/blob/master/Consolas%20NF/Consolas%20Nerd%20Font%20Complete%20Mono%20Windows%20Compatible.ttf
Systemd: https://github.com/DamionGans/ubuntu-wsl2-systemd-script

Win
Scoop:
iwr -useb get.scoop.sh | iex
scoop bucket add versions
scoop install wget gzip mingw go nvm python neovim-nightly llvm fd ripgrep
need:require 'nvim-treesitter.install'.compilers = { "clang" }

nvm install latest
nvm use latest
npm install --global neovim tree-sitter-cli

python -m pip install --user pynvim

Go stuff:

Powershell
Install-Module posh-git

Link:
new-item -itemtype symboliclink -path C:\Users\Hayden\AppData\Local -name nvim -value C:\Users\Hayden\dotfiles\nvim
