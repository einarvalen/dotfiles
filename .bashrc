
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
export http_proxy=http://proxy.vegvesen.no:8080
export PATH=~/bin:$PATH

alias agrep="ack-grep --ignore-dir=target"
alias jack="ack-grep --ignore-dir=target --type=java"
alias xack="ack-grep --ignore-dir=target --type=xml"
alias cack="ack-grep --ignore-dir=target --type=cpp --type=cc"
alias sack="ack-grep --ignore-dir=target --type=shell"
alias dack="ack-grep --ignore-dir=target --type=dlang"
alias rack="ack-grep --ignore-dir=target --type=ruby"
alias vim="vim -p"

function marialog {
	ssh -q exteva@tomcatlab04 "tail --lines=200 /tmp/maria.log" | less
}

function vmakepasswd {
	makepasswd --string '1234567890qwertyuiopQWERTYUIOPasdfghjklASDFGHJKKLzxcvbnmZXCVBNM'
}

function goodmorning {
	vim -p ~/Dropbox/timer.txt ~/Dropbox/todo.txt ~/Dropbox/notes.txt ~/Dropbox/einarvalen.com/howto/vim.txt
}

function timer {
	vim -p ~/Dropbox/timer.txt 
}

function notes {
	vim -p ~/Dropbox/todo.txt ~/Dropbox/notes.txt
}

function ubuntu-version {
	lsb_release -a
}

function vtmux {
    tmux new-session \; \
        rename-window notes \; \
        new-window -c ~/git/autopro/lib -n autopro \;  \
        new-window -c ~/git/svv_tomcat/manifests -n svv_tomcat \; \
        new-window -c ~/git/svv_httpd/manifests -n svv_httpd \; \
        new-window -c ~/git/autogen -n autogen \; \
        new-window -c ~/git/stm -n stm \; \
        new-window -c ~/git/mariasys/maria -n mariasys \; \
        new-window -c ~/git/fabel -n fabel\;
        #new-window -c ~/git/artifactresolver -n artifactresolver\;
        #new-window -c ~/git/svv_autopro -n svv_autopro \; \
        #new-window -c ~/git/basestat -n basestat \; \
        #new-window -c ~/git/svv_mcollective -n mco \; \
}

export docwebuser=tdwmariasyssa
export docwebpw=7siTZIBgj2TGAuwArE4B

#Ranger
export EDITOR=vim
export SHELL=bash

export autpro_maria_stm=Rsdhj1vnDRjPTnU5XEeL 
export autpro_maria_atm=CCjHEkUQAYRVrMZMXNeV 
export autpro_maria_prod=MNRaBTHnVvfoLvy2WYWS
export autpro_httpdtest_stm=3Ud4FPQJUkSgFWn6x8JM
export autpro_httpdtest_atm=PywE6rYVzAjrcPcSaiqd
export autpro_httpdtest_prod=KBxfSBrgvBi2O89QwQ1S
export passwd=UgQfDoaHjQM6krxUsRuF # UgQfDoaHjQM6krxUsRuF # yMq3hCJTA9wmL7EbqGUU # 1bCOa0Z19UKn0UeULhbx
export pwTjeAutopro_Mariasys_stm=UgQfDoaHjQM6krxUsRuF 
export pwTjeAutopro_Mariasys_atm=yMq3hCJTA9wmL7EbqGUU 
export pwTjeAutopro_Mariasys_prod=1bCOa0Z19UKn0UeULhbx
export pwTjeBase_mariasys_01_Autopro=MNRaBTHnVvfoLvy2WYWS # Rsdhj1vnDRjPTnU5XEeL
export pwTjeBase_mariasys_01_AutoproPROD=AVCKHKnVP8umufsE3jTC
export pwTjeBase_mariasys_01_AutoproATM=rnE5GwrRYmMwnUSJhmcY

