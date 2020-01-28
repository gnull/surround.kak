provide-module surround %{
  declare-option -docstring 'List of surrounding pairs' str-list surround_pairs ( ) { } [ ] < > '"' '"' "'" "'" ` ` “ ” ‘ ’ « » ‹ ›
  declare-option -hidden str surround_pairs_to_regex
  declare-option -docstring 'Commands to execute when entering surround mode' str-list surround_begin ''
  declare-option -docstring 'Commands to execute when leaving surround mode' str-list surround_end ''
  define-command surround -params .. -docstring 'Enter surround mode for the whole insert session' %{
    evaluate-commands %sh{
      # Generate hooks for inserting and deleting an opening pair.
      # Build surround_pairs_to_regex for matching a surrounding pair, that is used when inserting or deleting a space.
      main() {
        eval "set -- $kak_quoted_opt_surround_pairs \"\$@\""
        build_hooks "$@"
        build_regex "$@"
      }
      build_hooks() {
        while test $# -ge 2; do
          opening=$1 closing=$2
          shift 2
          kak_quoted_opening=$(kak_escape "$opening")
          kak_quoted_closing=$(kak_escape "$closing")
          kak_quoted_opening_regex=$(kak_escape "\\Q$opening\\E")
          echo "
            hook -group surround window InsertChar $kak_quoted_opening_regex %(surround-opening-inserted $kak_quoted_opening $kak_quoted_closing)
            hook -group surround window InsertDelete $kak_quoted_opening_regex %(surround-opening-deleted $kak_quoted_opening $kak_quoted_closing)
          "
        done
      }
      build_regex() {
        regex=''
        while test $# -ge 2; do
          opening=$1 closing=$2
          shift 2
          regex="$regex|(\\A\\Q$opening\\E.+\\Q$closing\\E\\z)"
        done
        regex=${regex#|}
        kak_quoted_regex=$(kak_escape "$regex")
        printf 'set-option window surround_pairs_to_regex %s\n' "$kak_quoted_regex"
      }
      kak_escape() {
        for argument do
          printf "'"
          printf '%s' "$argument" | sed "s/'/''/g"
          printf "'"
          printf ' '
        done
      }
      main "$@"
    }
    hook -group surround window InsertChar ' ' surround-space-inserted-or-deleted
    hook -group surround window InsertDelete ' ' surround-space-inserted-or-deleted
    # Enter surround mode for the whole insert session.
    hook -once window ModeChange 'pop:insert:.*' %{
      remove-hooks window surround
      evaluate-commands %opt{surround_end}
    }
    evaluate-commands %opt{surround_begin}
    execute-keys -with-hooks i
  }
  # ╭───────────────────────────────────╮
  # │ What ┊ Initial ┊ Insert ┊ Result  │
  # ├───────────────────────────────────┤
  # │  (   ┊  Tchou  ┊ (Tchou ┊ (Tchou) │
  # │      ┊  ‾‾‾‾‾  ┊  ‾‾‾‾‾ ┊  ‾‾‾‾‾  │
  # ╰───────────────────────────────────╯
  #
  # Insert the closing pair.
  define-command -hidden surround-opening-inserted -params 2 %{
    execute-keys -draft 'a' %arg{2}
  }
  # ╭──────────────────────────────────╮
  # │ What ┊ Initial ┊ Delete ┊ Result │
  # ├──────────────────────────────────┤
  # │  ⌫   ┊ (Tchou) ┊ Tchou) ┊ Tchou  │
  # │      ┊  ‾‾‾‾‾  ┊ ‾‾‾‾‾  ┊ ‾‾‾‾‾  │
  # ╰──────────────────────────────────╯
  #
  # Try to delete the closing pair.
  # The closing pair can be preceded by whitespaces.
  define-command -hidden surround-opening-deleted -params 2 %{
    try %{
      execute-keys -draft "<a-:>l<a-k>\Q%arg{2}\E<ret>d"
    } catch %{
      execute-keys -draft "<a-:>l<a-i><space>L<a-k>\Q%arg{2}\E<ret>d"
    } catch ''
  }
  # ╭─────────────────────────────────────────────╮
  # │ What ┊  Initial  ┊   Insert   ┊   Result    │
  # ├─────────────────────────────────────────────┤
  # │  ␣   ┊ (␣Tchou␣) ┊ (␣␣Tchou␣) ┊ (␣␣Tchou␣␣) │
  # │      ┊   ‾‾‾‾‾   ┊    ‾‾‾‾‾   ┊    ‾‾‾‾‾    │
  # ╰─────────────────────────────────────────────╯
  #
  # ╭───────────────────────────────────────────────────╮
  # │ What ┊    Initial    ┊    Delete    ┊   Result    │
  # ├───────────────────────────────────────────────────┤
  # │  ⌫   ┊ (␣␣␣Tchou␣␣␣) ┊ (␣␣Tchou␣␣␣) ┊ (␣␣Tchou␣␣) │
  # │      ┊     ‾‾‾‾‾     ┊    ‾‾‾‾‾     ┊    ‾‾‾‾‾    │
  # ╰───────────────────────────────────────────────────╯
  #
  # When inserting or deleting a space (always LHS), adjust the RHS if between a surrounding pair.
  # We evaluate the whole selections in a draft context,
  # and keep selections surrounded by a pair.
  # Finally, we adjust the padding on the remaining selections.
  define-command -hidden surround-space-inserted-or-deleted %{
    try %{
      evaluate-commands -draft %{
        evaluate-commands -itersel %{
          evaluate-commands -draft %{
            surround-select-surrounding-content
            surround-keep-surrounding-pair
          }
          surround-pad-surrounding-pair
        }
      }
    }
  }
  # Initial position: X␣␣[Tchou]␣␣␣Y
  # Result: [X␣␣Tchou␣␣␣Y]
  define-command -hidden surround-select-surrounding-content %{
    execute-keys '<a-?>\H<ret><a-:>?\H<ret>'
  }
  # Initial position: [X␣␣Tchou␣␣␣Y]
  # Result: [✓] if a pair, [✗] if not
  define-command -hidden surround-keep-surrounding-pair %{
    evaluate-commands -save-regs '/' %{
      set-register / %opt{surround_pairs_to_regex}
      execute-keys '<a-k><ret>'
    }
  }
  # Initial position: (␣␣[Tchou]␣␣␣)
  # Result: (␣␣[Tchou]␣␣)
  define-command -hidden surround-pad-surrounding-pair %{
    try %{
      # Try to select LHS spaces and copy padding to the RHS.
      # If LHS selection succeeds, we append a space to the RHS to ensure <a-i><space> does not fail.
      execute-keys -draft 'Zh<a-i><space>yza<space><esc><a-i><space>R'
    } catch %{
      # No LHS space, remove RHS spaces.
      execute-keys -draft '<a-:>l<a-i><space>d'
    } catch ''
  }
}

require-module surround
