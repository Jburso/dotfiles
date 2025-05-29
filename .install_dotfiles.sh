#!/bin/sh

: "${DOTFILES_INSTALL_DIR="$HOME/.dotfiles"}"
: "${DOTFILES_GIT_ALIAS=df}"
: "${DOTFILES_GIT_ALIAS_RAW=$DOTFILES_GIT_ALIAS-raw}"
: "${DOTFILES_GIT_BRANCH=base}"

set -e

DOTFILES_GIT_ALIAS_COMMAND="!git --git-dir=\"$DOTFILES_INSTALL_DIR\" --work-tree=\"$HOME\""

if [ "$DOTFILES_SSH" == "1" ]; then
  REPO_URL=git@github.com:Jburso/dotfiles.git
else
  REPO_URL=https://github.com/Jburso/dotfiles.git
fi

# Clone bare repo
git clone --bare "$REPO_URL" "$DOTFILES_INSTALL_DIR"

# Create global aliases
git config --global alias."$DOTFILES_GIT_ALIAS_RAW" "$DOTFILES_GIT_ALIAS_COMMAND"
git config --global alias."$DOTFILES_GIT_ALIAS" "!f() { \
  if [ \"\$1\" = \"merge\" ]; then \
    shift; \
    git $DOTFILES_GIT_ALIAS_RAW merge -s recursive -X ours \"\$@\"; \
  else \
    git $DOTFILES_GIT_ALIAS_RAW \"\$@\"; \
  fi; \
}; f"

# Set local options
git "$DOTFILES_GIT_ALIAS" config --local status.showUntrackedFiles no
git "$DOTFILES_GIT_ALIAS" config --local remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git "$DOTFILES_GIT_ALIAS" config --local checkout.defaultRemote origin

# Fetch, checkout, and then switch to branch
git "$DOTFILES_GIT_ALIAS" fetch
git "$DOTFILES_GIT_ALIAS" checkout
git "$DOTFILES_GIT_ALIAS" switch "$DOTFILES_GIT_BRANCH"
