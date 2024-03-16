# Hooks
# ═════

# Highlight the word under the cursor
# ───────────────────────────────────
set-face global CurWord +u
hook global NormalIdle .* %{
    eval -draft %{ try %{
        exec ,<a-i>w
        add-highlighter -override global/curword regex "%val{selection}" 0:CurWord
    } catch %{
        add-highlighter -override global/curword group
    } }
}

# Search for ctags file in parent directories, until you hit $HOME
# ────────────────────────────────────────────────────────────────
hook global KakBegin .* %{
    evaluate-commands %sh{
        path="$PWD"
        while [ "$path" != "$HOME" ] && [ "$path" != "/" ]; do
            if [ -e "./tags" ]; then
                printf "%s\n" "set-option -add current ctagsfiles %{$path/tags}"
                break
            else
                cd ..
                path="$PWD"
            fi
        done
    }
}
