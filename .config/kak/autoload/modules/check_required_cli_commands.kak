# Check if required  cli commands are installed.
# All commands added to required_cli_commands will be
# checked after all configuration files are read.
#
# Make sure to use a hook on ModuleLoaded if not in kakrc
# Usage:
#   require-module check_cli_commands
#   set-option -add required_cli_commands "git"
#
#   -or-
#
#   hook global ModuleLoaded check_cli_commands %{
#       set-option -add required_cli_commands "ripgrep"
#   }
# ══════════════════════════════════════════════════════════════════════════

provide-module check_cli_commands %{
    # Commands that are required
    declare-option -docstring 'Required CLI commands' str-list required_cli_commands
    declare-option -hidden -docstring 'User notification for commands that are not installed' str-list cli_commands_output

    # Performs the check
    define-command -docstring 'Check if required CLI commands are installed' check_cli_commands %{ eval %sh{
        not_found=""

        for cli_command in $kak_opt_required_cli_commands; do
            if ! command -v "$cli_command" > /dev/null; then
                not_found="${not_found:+${not_found}, }${cli_command}"
            fi
        done

        if [ -n "$not_found" ]; then
            output=$(printf 'Install the following required programs and make them available in your $PATH: %s' "$not_found")
            printf 'set-option global cli_commands_output %s\n' "$output"
            printf 'fail %s\n' "$output"
        else
            printf 'nop\n'
        fi
    }}

    # Automatically check commands after kak is done loading config
    # KakBegin doesn't propogate fail or info commands
    # so we use ClientCreate instead.
    hook -once global ClientCreate .* %{
        try %{
            check_cli_commands
        } catch %{
            info -style modal "%opt{cli_commands_output}"
        }
    }
}

