# Check if required cli commands are installed
# All commands added to required_cli_commands will be checked
# after all configuration files are read.
# Only commands that are truly required, not just supported should be added.
# For example, plug.kak require git to install plugins. However, even though
# ctags is supported, the configuration won't break without it and should be
# left out of this check. A comment would suffice in that case.
#
# Make sure to use a hook on ModuleLoaded if not in kakrc
# Usage:
#   require-module check_required_cli_commands
#   set-option -add required_cli_commands "git"
#
#   -or-
#
#   hook global ModuleLoaded check_required_cli_commands %{
#       set-option -add required_cli_commands "cargo"
#   }
# ════════════════════════════════════════════

provide-module check_required_cli_commands %{
    # Commands that are required
    declare-option -docstring 'CLI commands that are required to be installed' str-list required_cli_commands
    declare-option -hidden -docstring 'User notification for commands that are not installed' str-list required_cli_commands_output

    # Performs the check
    define-command -docstring 'Check if required CLI commands are installed' check_required_cli_commands %{ eval %sh{
        # Required commands go here
        # plugin_requirements="ripgrep git fzf cargo"
        not_found=""

        while read -r requirement; do
            if ! command -v "$requirement" > /dev/null; then
                not_found="${not_found:+${not_found}, }${requirement}"
            fi
        done <<< "$(echo "$kak_opt_required_cli_commands" | tr ' ' '\n')"

        if [ -n "$not_found" ]; then
            output=$(printf 'Install the following required programs and make them available in your $PATH: %s' "$not_found")
            printf 'set-option global required_cli_commands_output %s\n' "$output"
            printf 'fail $s\n' "$output"
        else
            printf 'nop\n'
        fi
    }}

    # Automatically check commands after kak is done loading config
    # KakBegin does not propogate fail or info commands
    hook -once global ClientCreate .* %{
        try %{
            check_required_cli_commands
        } catch %{
            info -style modal "%opt{required_cli_commands_output}"
        }
    }
}

