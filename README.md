# Jack's dotfiles

## Usage
The default branch contains only this README.
Different branches represent configurations that are incompatible with each other.
The following branches are currently maintained and are subject to change:

- `base` - Common base config.
- `mac`  - macOS config.

## Install
`curl` the install script and pipe to `sh`. Verify the script before running
```
curl --proto '=https' -LSsf https://dotfiles.jburso.com | sh
```

To interact with the dotfiles git, prefix all commands with `git df`.

Examples:
- `git df switch base`
- `git df status`
- `git df log`

## Configuration Documentation

### Kakoune
Run `kak`, install all required cli commands, then install the plugins with:
```
:plug-install
```

## Uninstall
Run the uninstall script in the readme branch, assuming the bare repo was cloned to `~/.dotfiles`.
The dotfiles repo and all configuration files will be removed.
```
git df switch readme
~/.uninstall_dotfiles.sh
```
