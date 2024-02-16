# Commands
# ═════════

# Set up an IDE-like environment
# ──────────────────────────────
define-command ide -params 0..1 -docstring '[session-name]: Turn Kakoune into an IDE' %{
    evaluate-commands %sh{
        # Set the session name to the parameter, or set it to the current directory
        if [ -n "${1+x}" ]; then
            session_name="$1"
        else
            session_name=$(basename "$PWD")
        fi
        printf 'rename-session %s\n' "$session_name"
    }

    # Define a client for tool and documentation output
    rename-client ref
    buffer *debug*
    set-option global toolsclient ref
    set-option global docsclient ref

    # Define a secondary client
    new %{
        rename-client secondary
        set-option global jumpclient secondary
        # set-option window scrolloff 9999,0
        # set-option current readonly true
    }

    # Define the main client
    new %{
         rename-client main
        # addhl -override window/ column 80 Information
    }

    # Create a repl if using tmux
    nop %sh{
        if [ "$TMUX" ]; then
            # Format our panes
            tmux select-layout even-horizontal
            # We want the repl to be below the ref client
            tmux select-pane -L
            # Tell kak to create a repl vertically
            echo "tmux-repl-vertical" > "$kak_command_fifo"
            # Wait for the aboce command to finish
            sleep 0.1
            # Go back to the main editor
            tmux select-pane -R
        fi
    }

    # Configure plugins
    try %{
        # Configure kak-lsp
        map global user l %{:enter-user-mode lsp<ret>} -docstring "LSP mode"
        hook global WinSetOption filetype=(rust) %{
            lsp-inlay-hints-enable global
            lsp-inlay-diagnostics-enable global
            lsp-inline-diagnostics-enable global
            # lsp-auto-hover-enable ref
        }
    }
}
