# Jack's dotfiles

## Installing
If you are interested in just taking a look at the repository, a normal `git clone` will suffice.
However, if you want to install the dotfiles, use something similar to the following commands:
```
git clone --bare <repo-url> $HOME/.dotfiles # Specify the .git directory as a subdirectory
git config --global alias.dotfiles '!git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' # Specify where the .git is and where to checkout to
git dotfiles --local status.showUntrackedFiles no # Don't flood status with all of $HOME
git dotfiles checkout # Checkout the dotfiles
```

## Branches
The default branch contains only this README.
Different branches represent configurations that are incompatible with each other.
The following branches are currently maintained and are subject to change:

- `base` - Base configuration for all other configurations.

## Kakoune
Run `kak`, install all required cli commands, then install the plugins with:
```
:plug-install
```
