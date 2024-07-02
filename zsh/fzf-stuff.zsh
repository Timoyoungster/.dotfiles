
#######################################
# CTRL-T - cd into selected directory #
#######################################

fzf-file-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  f=$(find ~/github ~/.config/* ~/downloads/* ~/ ~/github/jku ~/github/project-wasteland/* ~/github/zmk-config/* -mindepth 0 -maxdepth 2 -type d | fzf --bind "ctrl-y:accept")
  if [ -z $f ]; then; else
    nvim $f
  fi
  zle reset-prompt
}

zle     -N            fzf-file-widget
bindkey -M emacs '^T' fzf-file-widget
bindkey -M vicmd '^T' fzf-file-widget
bindkey -M viins '^T' fzf-file-widget

# TODO: implement history search
#
fzf-history-widget() {
  setopt extendedglob

  FC_ARGS="-l"
  CANDIDATE_LEADING_FIELDS=2

  if (( ! $ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS )); then
    FC_ARGS+=" -n"
    ((CANDIDATE_LEADING_FIELDS--))
  fi

  if (( $ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH )); then
    FC_ARGS+=" -i"
    ((CANDIDATE_LEADING_FIELDS+=2))
  fi

  history_cmd="fc ${=FC_ARGS} -1 0 | awk '!seen[\$0]++'"

  if (( $#BUFFER )); then
    candidates=(${(f)"$(eval $history_cmd | fzf --bind 'ctrl-y:accept' ${=ZSH_FZF_HISTORY_SEARCH_FZF_ARGS} ${=ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS} -q "${=ZSH_FZF_HISTORY_SEARCH_FZF_QUERY_PREFIX}$BUFFER")"})
  else
    candidates=(${(f)"$(eval $history_cmd | fzf --bind 'ctrl-y:accept' ${=ZSH_FZF_HISTORY_SEARCH_FZF_ARGS} ${=ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS})"})
  fi

  if [ -n "$candidates" ]; then
    if (( ! $CANDIDATE_LEADING_FIELDS == 1 )); then
      BUFFER="${candidates[@]/(#m)[0-9 \-\:]##/$(
      printf '%s' "${${(As: :)MATCH}[${CANDIDATE_LEADING_FIELDS},-1]}" | sed 's/%/%%/g'
      )}"
    else
      BUFFER="${(j| && |)candidates}"
    fi
    zle vi-fetch-history -n $BUFFER
    if [ -n "${ZSH_FZF_HISTORY_SEARCH_END_OF_LINE}" ]; then
      zle end-of-line
    fi
  fi
}

zle     -N            fzf-history-widget
bindkey -M emacs '^R' fzf-history-widget
bindkey -M vicmd '^R' fzf-history-widget
bindkey -M viins '^R' fzf-history-widget
