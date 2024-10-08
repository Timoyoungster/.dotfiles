###########
# Globals #
###########

export SEARCHPATHS=( ~/github ~/.config/* ~/downloads/* ~ ~/github/jku ~/github/project-wasteland/* ~/github/zmk-config/* ~/github/project-wasteland/asm/*)
export WWW_HOME=www.duckduckgo.com

##############
# Completion #
##############

# autocomplete dots
setopt globdots

# case insensitive completion
autoload -Uz +X compinit && compinit

## case insensitive path-completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
setopt MENU_COMPLETE
setopt DVORAK # spelling mistakes wrt. dvorak layout
setopt no_list_ambiguous

############
# Bindings #
############

# disable software flow control thingy
stty -ixon

# nvim editor but no zsh-vi mode
export VISUAL=nvim
export EDITOR=$VISUAL
bindkey -e

# fzf
source ~/.config/zsh/fzf-stuff

# vim-style completion navigation
bindkey '^N' expand-or-complete
bindkey '^P' reverse-menu-complete
bindkey '^Y' accept-line

##########
# Prompt #
##########

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

########
# PATH #
########

export PATH=$PATH:$HOME/.cargo/env
export PATH=$PATH:/home/timo/go/bin
export PATH=$PATH:./node_modules/.bin
export PATH=~/.config/scripts:$PATH

# Created by `pipx` on 2024-05-27 16:55:57
export PATH="$PATH:/home/timo/.local/bin"

###########
# Aliases #
###########

alias sudo='sudo ' # make aliases work with sudo http://www.linuxcommand.org/lc3_man_pages/aliash.html
alias ll="ls -a -h -l --color=always -v"
alias lx="ls -a -h --color=always -v"
alias lxs="ls -a -h -l --color=always --group-directories-first -v | less -R"
alias gs="git status"
alias gd="git diff"
alias ga="git add --all"
alias gc="git commit"
alias gco="git checkout"
alias gb="git branch"
alias gp="git push"
alias gpull="git pull"
alias gor="go run ."
alias zshconfig="nvim ~/.zshrc"
alias nvimconfig="cd ~/.config/nvim"
alias dotfiles="cd ~/.config"
alias res="fg"
alias hl='Hyprland'
alias imgcat='img2sixel' // better: viu
alias clock='tclock' # cargo install clock-tui
alias weather='curl wttr.in/48.11,14.19'
alias hextobin='python3 ~/.config/scripts/hex_to_bin.py $@'
alias work='virtualboxvm --startvm "Windows"'
alias wm='w3m -v www.duckduckgo.com'
alias duck='cat ~/.config/zsh/duck'
alias cpoeu='wl-copy Ö'
alias cpaeu='wl-copy Ä'
alias cpueu='wl-copy Ü'
alias cpoe='wl-copy ö'
alias cpae='wl-copy ä'
alias cpue='wl-copy ü'
alias gcc-arm='arm-none-eabi-gcc'
alias gcc-arm-no='arm-none-eabi-gcc -static -nostdlib'
alias gdb-arm='arm-none-eabi-gdb'
alias objdump='objdump -M intel --no-show-raw-insn'
alias objdump-arm='arm-none-eabi-objdump --no-show-raw-insn'

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

if [[ -f ~/.config/zsh/ssh-stuff ]]
then
  source ~/.config/zsh/ssh-stuff
fi

source ~/.config/zsh/password-stuff
