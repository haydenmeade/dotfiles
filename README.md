# DOTFILES

```
git clone https://github.com/haydenmeade/dotfiles && cd dotfiles && ./ubuntu
git clone https://github.com/haydenmeade/dotfiles && cd dotfiles && ./macos
```

## Neovim

```
bash ./installnvimfromrelease.sh
```

### linux:

```
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim -y
```

### Windows:

```
scoop bucket add versions
scoop install neovim-nightly
```

### OSX

```
brew install --HEAD neovim
```

## Dependencies:

git
zsh
stow
curl
wget
gzip
lazygit
fzf
shellcheck
rbenv
ruby-build
jq
nvm
python3
llvm
lua-language-server

> Windows only:

mingw

## ZSH

> https://github.com/ohmyzsh/ohmyzsh

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

```
git clone https://github.com/lukechilds/zsh-nvm ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-nvm
git clone https://github.com/mroth/evalcache ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/evalcache
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-vi-mode
```

> go

https://github.com/canha/golang-tools-install-script
_go doesn't seem to work on windows from scoop?_

```
go install mvdan.cc/gofumpt@latest mvdan.cc/sh/v3/cmd/shfmt@latest
```

> Node.js

```
nvm install latest
nvm use latest
npm install --global neovim tree-sitter-cli eslint_d eslint typescript typescript-language-server @fsouza/prettierd jsonls bash-language-server
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

> C/C++

clangd: https://clangd.llvm.org/installation.html

## Windows(WSL):

Systemd: https://github.com/DamionGans/ubuntu-wsl2-systemd-script

> Scoop

```
iwr -useb get.scoop.sh | iex
```

> Powershell

```
Install-Module posh-git
new-item -itemtype symboliclink -path C:\Users\Hayden\AppData\Local -name nvim -value C:\Users\Hayden\dotfiles\nvim
```
