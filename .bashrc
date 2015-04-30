shopt -s checkwinsize

shopt -s histappend
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=10000

# Move /usr/local/bin before /usr/bin first for homebrew.
# (Can't just do export PATH=/usr/local/bin:$PATH; breaks vex).
export PATH=$(python -c "import sys; p = sys.argv[1].split(':'); p.remove('/usr/local/bin'); p.insert(p.index('/usr/bin'), '/usr/local/bin'); print(':'.join(p))" $PATH)
export PATH=$HOME/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export GOPATH=$HOME/code/go
export PATH=$GOPATH/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

export NODE_PATH=/usr/local/share/npm/lib/node_modules

function has { command -v "$1" >/dev/null 2>&1; }

export TERM='xterm-256color'
# This makes `tree` use the same colors as `ls`
if has gdircolors; then
  eval "$(gdircolors -b)"
else
  eval "$(dircolors -b)"
fi

# Make less behave like in git
# F: quit if less than one screen
# S: chop long lines
# R: enable colors
# X: don't clear the screen on exit
export LESS="FSRX"

if has mvim; then
  export EDITOR='mvim -v'
  alias vi='mvim -v'
  alias vim='mvim -v'
else
  export EDITOR='vim'
fi

if [ "$(uname)" == "Darwin" ]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
alias ag='ag --smart-case'

alias t='python ~/code/py/t/t.py --task-dir ~/.tasks --list tasks'
alias rainbow='jot -b# $(tput cols) | tr -d '\'\\n\'' | xargs yes | lolcat'

function cd {
    builtin cd "$@" && ls
}

BLACK="\[\033[30m\]"
BLACK_BOLD="\[\033[0;30;1m\]"
RED="\[\033[31m\]"
RED_BOLD="\[\033[0;31;1m\]"
GREEN="\[\033[32m\]"
GREEN_BOLD="\[\033[0;32;1m\]"
YELLOW="\[\033[33m\]"
YELLOW_BOLD="\[\033[0;33;1m\]"
BLUE="\[\033[34m\]"
BLUE_BOLD="\[\033[0;34;1m\]"
MAGENTA="\[\033[35m\]"
MAGENTA_BOLD="\[\033[0;35;1m\]"
CYAN="\[\033[36m\]"
CYAN_BOLD="\[\033[0;36;1m\]"
WHITE="\[\033[37m\]"
WHITE_BOLD="\[\033[0;37;1m\]"
RESET="\[\033[0m\]"

function git_branch {
  git rev-parse --abbrev-ref HEAD 2>/dev/null | sed -e 's/\(..*\)/ (\1)/'
}

PS1="\u@\h:\w${GREEN}\$(git_branch)${RESET}$ "

if has brew; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
      source $(brew --prefix)/etc/bash_completion
  fi
fi

if has vex; then
  eval "$(vex --shell-config bash)"
fi

# Completion for vim -t, adapted from
# http://vim.wikia.com/wiki/Using_bash_completion_with_ctags_and_Vim
function _vim_ctags {
	local cur prev
	cur=${COMP_WORDS[COMP_CWORD]}
	prev=${COMP_WORDS[COMP_CWORD-1]}
	[[ $prev = -t ]] || return
	local tagsdir=$PWD
	while [[ "$tagsdir" && ! -f "$tagsdir/tags" ]]; do
		tagsdir=${tagsdir%/*}
	done
	[[ -f "$tagsdir/tags" ]] || return
	COMPREPLY=( $(grep -o "^$cur[^	]*" "$tagsdir/tags" ) )
}
complete -F _vim_ctags -f vi vim view
