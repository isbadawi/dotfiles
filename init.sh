#!/bin/bash
set -e

this_dir=$(cd "$(dirname "$0")" && pwd)

function link {
  local source="$1"
  local target="$2"
  if [ -e $target ]; then
    echo "$target exists, backing up to $target.old just in case"
    mv $target $target.old
  fi
  ln -vs $source $target
}

function init_vim {
  echo "Installing pathogen..."
  mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle
  curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
  echo "Installing vpm..."
  git submodule update --init --remote vpm
  mkdir -p $HOME/bin
  link $this_dir/vpm/vpm $HOME/bin/vpm
  echo "Installing vim plugins..."
  ./vpm-export.sh
}

function link_dotfiles {
  local symlinks=".bashrc .ctags .gitconfig .githelpers .inputrc .vimrc"
  for symlink in $symlinks; do
    link $this_dir/$symlink $HOME/$symlink
  done
}

function main {
  link_dotfiles
  source $HOME/.bashrc
  init_vim
}

main
