alias lx="ls -a -h -l --color=always --group-directories-first -v"
alias lp="ls -a -h --color=always --group-directories-first -v"
alias lxs="ls -a -h -l --color=always --group-directories-first -v | less -R"
alias gs="git status"
alias gd="git diff"
alias ga="git add --all"
alias gc="git commit"
alias gp="git push"
alias gpull="git pull"
alias zshconfig="nvim ~/.zshrc"
alias nvimconfig="cd ~/.config/nvim; nvim .;"
alias dotfiles="cd ~/.config; nvim .;"
alias res="fg"
alias hl='Hyprland'
alias imgcat='img2sixel'

eval $(thefuck --alias)

pyvenv_projects=(
  "pip" 
  "hoai" 
  "algodat"
)

function uni () {
  if [ $# -eq 1 ]
  then
    cd ~/github/jku/semester2/$1/*(/om[1])
    if [ $pyvenv_projects[(i)$1] ]
    then
      source ~/.pythonvenv/uni/bin/activate || return
    fi
  else
    cd ~/github/jku
  fi
}

function zat () {
  zathura $* &; disown
}

function xdump () {
  if [ $# -eq 2 ]
  then
    objdump -D $1 > $2
  else
    objdump -D --disassembler-color=extended-color $1 | less -r
  fi
}

function tx () {
  if [ $# -eq 0 ]
  then
    tmux list-sessions
  else
    tmux new -As $1
  fi
}

function venv () {
  source ~/.pythonvenv/$1/bin/activate || return
  echo "Activated python venv '$1'!"
}

function vim () {
  if [ $# -eq 0 ]
  then
    nvim .
  else
    nvim $@
  fi
}

function Rrender () {
  if [ $# -eq 0 ]
  then
    echo "No file specified"
  else
    Rscript -e "rmarkdown::render('$1')"
  fi
}

function zmk_build_both () {
  cd ~/github/zmk-config
  git pull
  cd -
  if [[ "$VIRTUAL_ENV" == "" ]]
  then
    venv zmk
  fi
  west build -d build/left -b nice_nano_v2 -- -DSHIELD=cradio_left -DZMK_CONFIG="/home/timo/github/zmk-config/config" -DZMK_EXTRA_MODULES="/home/timo/github/zmk-config/"
  west build -d build/right -b nice_nano_v2 -- -DSHIELD=cradio_right -DZMK_CONFIG="/home/timo/github/zmk-config/config" -DZMK_EXTRA_MODULES="/home/timo/github/zmk-config/"
}

# autocomplete dots
setopt globdots

# case insensitive completion
autoload -Uz +X compinit && compinit

## case insensitive path-completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
setopt MENU_COMPLETE
setopt no_list_ambiguous

# vim mode
bindkey -v
export KEYTIMEOUT=1

# reactivate reverse search
bindkey '^R' history-incremental-pattern-search-backward

# vim-style completion navigation
bindkey '^N' expand-or-complete
bindkey '^P' reverse-menu-complete
bindkey '^Y' accept-line

# custom prompt
setopt promptsubst
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '?'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '(%b%c%u) '
PROMPT='%F{yellow}%(1j.(%j jobs) .)%f%. %F{red}$vcs_info_msg_0_%f%% '

PATH="$PATH:/home/timo/go/bin"
PATH="$PATH:./node_modules/.bin"

export VISUAL=nvim
export EDITOR="$VISUAL"

# Created by `pipx` on 2024-05-27 16:55:57
export PATH="$PATH:/home/timo/.local/bin"

