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

# Install and configure all plugins
# ─────────────────────────────────
plug "andreyorst/plug.kak" noload

plug "alexherbo2/auto-pairs.kak" config %{
    enable-auto-pairs
}

set-option -add global required_cli_commands "fzf"
set-option -add global required_cli_commands "rg"
plug "andreyorst/fzf.kak" config %{
    map global user f %{:fzf-mode<ret>} -docstring "fzf mode"
} defer fzf %{
    # Ubuntu 20.04 fzf is too old to support preview features (needs --preview-window=\${pos}:+{2}-{/2})
    # Set this to true if on >= 22.04
    set-option global fzf_preview true
    set-option global fzf_tmux_popup true
    set-option global fzf_tmux_popup_width 80%
} defer fzf-grep %{
    set-option global fzf_grep_command rg
    # Set this to true if on >= 22.04
    set-option global fzf_grep_preview true
}

set-option -add global required_cli_commands "cargo"
plug "kakoune-lsp/kakoune-lsp" do %{
    cargo install --locked --force --path .
    mkdir -p ~/.config/kak-lsp
    cp -n kak-lsp.toml ~/.config/kak-lsp/
} config %{
    # Uncomment to enable debugging
    # set global lsp_cmd "kak-lsp -s %val{session} -vvv --log /tmp/kak-lsp.log"
}

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

plug "occivink/kakoune-find"

}
