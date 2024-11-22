# Plugins
# ═══════

# Make sure we can check required cli commands before loading anything
hook global ModuleLoaded check_cli_commands %{

# Initialize autoload and plugin directories
# ──────────────────────────────────────────
set-option -add global required_cli_commands "git"
declare-option -hidden str git_domain "https://github.com"

evaluate-commands %sh{
    plugins="$kak_config/plugins"
	if [ ! -e "$plugins" ]; then
        mkdir -p "$plugins"
		git -C "$plugins/" clone -q "$kak_opt_git_domain/andreyorst/plug.kak.git"
    fi
    printf "%s\n" "source '$plugins/plug.kak/rc/plug.kak'"
}

# Must be set after sourcing plug.kak
set-option current plug_git_domain %opt{git_domain}

# plug.kak
# ────────
plug "andreyorst/plug.kak" noload

# auto-pairs.kak
# ──────────────
plug "alexherbo2/auto-pairs.kak" config %{
    enable-auto-pairs
}

# fzf.kak
# ───────
set-option -add global required_cli_commands "fzf"
set-option -add global required_cli_commands "rg"
plug "andreyorst/fzf.kak" config %{
    map global user f %{:fzf-mode<ret>} -docstring "fzf mode"
} defer fzf %{
    # Ubuntu 20.04 fzf is too old to support preview features (needs --preview-window=\${pos}:+{2}-{/2})
    # Set this to true if on >= 22.04
    set-option global fzf_preview true
    set-option global fzf_tmux_popup true
    set-option global fzf_tmux_height 75%
    set-option global fzf_tmux_popup_width 80%
} defer fzf-grep %{
    set-option global fzf_grep_command rg
    # Set this to true if on >= 22.04
    set-option global fzf_grep_preview true
}

# kakoune-lsp
# ───────────
set-option -add global required_cli_commands "cargo"
plug "kakoune-lsp/kakoune-lsp" do %{
    cargo install --locked --force --path .
} config %{
    eval %sh{kak-lsp}
    lsp-enable

    map global user l ':enter-user-mode lsp<ret>' -docstring 'LSP mode'

    map global insert <tab> '<a-;>:try lsp-snippets-select-next-placeholders catch %{ execute-keys -with-hooks <lt>tab> }<ret>' -docstring 'Select next snippet placeholder'

    map global object a '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
    map global object <a-a> '<a-semicolon>lsp-object<ret>' -docstring 'LSP any symbol'
    map global object f '<a-semicolon>lsp-object Function Method<ret>' -docstring 'LSP function or method'
    map global object t '<a-semicolon>lsp-object Class Interface Struct<ret>' -docstring 'LSP class interface or struct'
    map global object d '<a-semicolon>lsp-diagnostic-object --include-warnings<ret>' -docstring 'LSP errors and warnings'
    map global object D '<a-semicolon>lsp-diagnostic-object<ret>' -docstring 'LSP errors'

    lsp-inlay-hints-enable global
    lsp-inlay-diagnostics-enable global

} noload

# hop.kak
# ───────
set-option -add global required_cli_commands "cargo"
plug "phaazon/hop.kak" do %{
    cargo install --locked --force --path .
} config %{
    # Source hop-kak required options
    evaluate-commands %sh{ hop-kak --init }
    # Create a command to send all words in the buffer (that can be viewed), to hop-kak
    define-command -override hop-kak-words %{
        exec 'gtGbxs\w+<ret>:eval -no-hooks -- %sh{ hop-kak --keyset qwxecrsdgfjhklunimop --sels "$kak_selections_desc" }<ret>'
    }
    # Create a helper mapping
    map global user h %{:hop-kak-words<ret>} -docstring "hop to word"
}

# kakoune-find
# ────────────
plug "occivink/kakoune-find"

# kak-tree-sitter
# ───────────────
plug "https://git.sr.ht/~hadronized/kak-tree-sitter" do %{
    cargo install --locked --force --path kak-tree-sitter
    cargo install --locked --force --path ktsctl
} config %{
    eval %sh{ kak-tree-sitter -dks --init $kak_session }
} noload

# Grab some tree-sitter enabled kakoune themes
plug "https://git.sr.ht/~hadronized/kakoune-tree-sitter-themes" theme config %{
    colorscheme catppuccin_mocha
}

} # End of check_cli_commands hook

