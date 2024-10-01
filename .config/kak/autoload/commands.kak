# Commands
# ═════════

# Create a new horizontal kakoune client
# ──────────────────────────────────────
define-command newh -params .. -docstring 'newh [<commands>]: create a new horizontal Kakoune client' %{
    try %{
        set-option local windowing_placement horizontal
        new "%arg{@}"
    } catch %{
        set-option local windowing_placement window
        new "%arg{@}"
    }
}

# Create a new vertical kakoune client
# ────────────────────────────────────
define-command newv -params .. -docstring 'newv [<commands>]: create a new vertical Kakoune client' %{
    try %{
        set-option local windowing_placement vertical
        new "%arg{@}"
    } catch %{
        set-option local windowing_placement window
        new "%arg{@}"
    }
}

# Start LSP with default configuration
# ────────────────────────────────────

# It looks like eval%sh{kak-lsp} needs to be run on Kakoune startup,
# before the buffer opens, in order for the lsp_language_id hooks
# to run. What's written below unfortunately won't work due to this.
# Check back later to see if this gets fixed. 

# define-command custom-lsp -docstring 'lsp: start LSP with default configuration' %{
#     eval %sh{kak-lsp}
#     map global user l %{:enter-user-mode lsp<ret>} -docstring "LSP mode"
#     hook global WinSetOption filetype=(rust|c|cpp) %{
#         echo -debug "here"
#         lsp-enable-window
#         lsp-inlay-hints-enable global
#         lsp-inlay-diagnostics-enable global
#         lsp-inline-diagnostics-enable global
#     }

# }

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
    rename-client secondary
    buffer *debug*
    set-option global toolsclient secondary
    set-option global docsclient secondary
    set-option global jumpclient secondary
    # set-option window scrolloff 9999,0
    # set-option current readonly true

    # Define the main client
    newh %{
         rename-client main
        # addhl -override window/ column 80 Information
    }

    focus secondary

    # Create a repl if using tmux
    nop %sh{
        if [ $kak_opt_windowing_module == "tmux" ]; then
            # Tell kak to create a repl vertically
            echo "tmux-repl-vertical" > "$kak_command_fifo"
            # Wait for the above command to finish
            sleep 0.1
            # Go back to the main editor
            tmux select-pane -R
        fi
    }

}
