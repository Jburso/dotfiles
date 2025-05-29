#!/bin/sh

DOTFILES_GIT="$HOME/.dotfiles"
: "${DOTFILES_GIT_ALIAS=df}"

usage() {
  printf "$0 [path_to_dotfiles_git]\n"
  printf "Default path to dotfiles git is $DOTFILES_GIT\n"

  exit $1
}

if [ $# -eq 1  ]; then
  if [ $1 = "-h" ] || [ $1 = '--help' ]; then
    usage 0
  else
    DOTFILES_GIT=$1
  fi
fi

if [ ! -d "$DOTFILES_GIT" ]; then
  printf "Are the dotfiles installed? "$DOTFILES_GIT" does not exist.\n" > /dev/stderr
  usage 255
fi

set -e

# Remove all checked out files
cd "$HOME"
git "$DOTFILES_GIT_ALIAS" ls-tree --full-tree --name-only HEAD | xargs rm -rf
cd - >/dev/null

# Unset git dotfiles alias
git config --global --unset alias.dotfiles

# Remove dotfiles git directory
rm -rf "$DOTFILES_GIT"
