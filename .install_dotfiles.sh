#!/bin/sh

: "${INSTALL_DIR="$HOME/.dotfiles"}"
: "${GIT_ALIAS='dotfiles'}"
: "${REPO_URL='https://github.com/Jburso/dotfiles.git'}"

GIT_ALIAS_COMMAND="!git --git-dir=\"$INSTALL_DIR\" --work-tree=\"$HOME\""

git clone --bare "$REPO_URL" "$INSTALL_DIR"
git config --global alias."$GIT_ALIAS" "$GIT_ALIAS_COMMAND"
git --git-dir="$INSTALL_DIR" config --local status.showUntrackedFiles no
git "$GIT_ALIAS" checkout
