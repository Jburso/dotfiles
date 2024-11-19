#!/bin/sh

set -e

# Remove all checked out files
git dotfiles ls-tree --full-tree --name-only HEAD | xargs rm -rf

# Remove dotfiles git directory
rm -rf $HOME/.dotfiles
