# Jack's dotfiles

## Usage
The default branch contains only this README.
Different branches represent configurations that are incompatible with each other.
The following branches are currently maintained and are subject to change:

- `base` - Base configuration for all other configurations.

## Install
If you are interested in just taking a look at the repository, a normal `git clone` will suffice.
However, if you want to install the dotfiles, use the following commands:

### Clone the .git directory as a subdirectory
```
git clone --bare <repo-url> $HOME/.dotfiles
```

### Install the dotfiles
```
git config --global alias.dotfiles '!git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' # Specify where the .git is and where to checkout to
git --git-dir=$HOME/.dotfiles/ config --local status.showUntrackedFiles no             # Don't flood status with all of $HOME
git dotfiles checkout                                                                  # Checkout the dotfiles
```

### Switch to the desired branch
```
git dotfiles switch <branch_name>
```
To interact with the dotfiles git, prefix all commands with `git dotfiles`.

Examples:
- `git dotfiles switch base`
- `git dotfiles status`
- `git dotfiles log`

## Configuration Documentation

### Kakoune
Run `kak`, install all required cli commands, then install the plugins with:
```
:plug-install
```

## Uninstall
Run the uninstall script in the readme branch, assuming the bare repo was cloned to $HOME/.dotfiles.
The dotfiles repo and all configuration files will be removed.
```
git dotfiles switch readme
~/.uninstall_dotfiles.sh
```
