# DOTFILES

```
git clone https://github.com/haydenmeade/dotfiles && cd dotfiles && ./install
```

to check out:
andythigpen / nvim-coverage
b0o / SchemaStore.nvim

## Setup:

### Neovim

```
bash ./installnvimfromrelease.sh
```

or

## linux:

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim -y

## Windows:

```
scoop bucket add versions
scoop install neovim-nightly
```

## Dependencies:

gzip
nvm
curl
rbenv
ruby-build
shellcheck
jq
fzf
git
wget
python3
llvm

> Windows only:

mingw

> go packages

https://github.com/canha/golang-tools-install-script
_go doesn't seem to work on windows from scoop?_

```
go install mvdan.cc/gofumpt@latest
go install github.com/mgechev/revive@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

> ruby gems

```
gem install solargraph
```

> Node

```
nvm install latest
nvm use latest
npm install --global neovim tree-sitter-cli eslint_d typescript typescript-language-server @fsouza/prettierd
```

> python

```
python -m pip install --user pynvim
```

> rust

https://www.rust-lang.org/tools/install

```
cargo install stylua ripgrep exa bat fd
```

- https://gorails.com/setup/windows/10

> C/C++

clangd: https://clangd.llvm.org/installation.html

## Windows(WSL):

Systemd: https://github.com/DamionGans/ubuntu-wsl2-systemd-script
Scoop:

```
iwr -useb get.scoop.sh | iex
```

> Powershell

```
Install-Module posh-git
new-item -itemtype symboliclink -path C:\Users\Hayden\AppData\Local -name nvim -value C:\Users\Hayden\dotfiles\nvim
```
