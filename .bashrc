# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
PS1='[\u@\h->\W]\$ '
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

#xmodmap -e "clear Lock"
ulimit -c unlimited
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre
export LD_LIBRARY_PATH=~/opt/lib/:/usr/lib/jni:/usr/local/lib:.

export MAVEN_OPTS_NODEBUG="-DCONSTRETTO_TAGS=DEV -XX:MaxPermSize=256M -Xms512m -Xmx1024m"
export MAVEN_OPTS_DEBUG="-DCONSTRETTO_TAGS=DEV -XX:MaxPermSize=256M -Xms512m -Xmx1024m -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=4000,server=y,suspend=y"
export MAVEN_OPTS=$MAVEN_OPTS_NODEBUG
shopt -s histappend
export HISTCONTROL=ignoreboth
export HISTSIZE=1000000 HISTFILESIZE=1000000


function vshortcuts() { # List shorcuts
	echo LogfileShortcuts:
	LogfileShortcuts.py -?
	echo
	echo DirectoryShortcuts:
	DirectoryShortcuts.py -?
	echo
	echo CommandShortcuts:
	CommandShortcuts.py -?
}

function vcd() { # cd with tailored shortcut. See DirectoryShortcuts
	folder=`DirectoryShortcuts.py $1`
	cd $folder
}

function vhelp { # HELP DISPLAY
	grep "^function .*{.*#" ~/.bashrc
}

function vmci() { # Maven build with DirectoryShortcuts
	for var in "$@"
	do
		folder=`DirectoryShortcuts.py $var`
		echo $folder
		(cd $folder && mvn3 -o clean install)
	done
}

function vmvn() { # Maven build with CommandShortcuts
	commands=`CommandShortcuts.py $@`
	echo mvn3 $commands
	mvn3 $commands
}

function vcreate-project() { # Create Maven project
	if [ "$1" = "w" ]; then
		mvn archetype:generate -DarchetypeArtifactId=maven-archetype-webapp  -DgroupId=org.einarvalen -DartifactId=$2
	elif [ "$1" = "r" ]; then
		mvn archetype:generate -DarchetypeGroupId=org.apache.maven.archetypes -DgroupId=org.einarvalen -DartifactId=$2
	else
		echo vcreate-project w|r  project-name r=regular project, w=war project
	fi
}

function vutf8 { # convert files from iso8859 to utf8
	for file in $1; do
	iconv --from-code=ISO-8859-1 --to-code=UTF-8 $file > /tmp/utf8conv;
	rm $file;
	mv /tmp/utf8conv $file;
	done
}

function vfz3 { #Start filezilla3
	~/opt/FileZilla3/bin/filezilla &
}

function vthunderbird { # Start thunderbird
	ps -ef | grep thun[d]erbird | awk '{printf("kill %s\n", $2);}' | bash
	thunderbird >/dev/null 2>&1 &
}

function vpidgin { # Start pidgin
	ps -ef | grep pid[g]in | awk '{printf("kill %s\n", $2);}' | bash
	pidgin >/dev/null 2>&1 &
}

function vgnote { # Start gnote
	ps -ef | grep g[n]ote | awk '{printf("kill %s\n", $2);}' | bash
	gnote >/dev/null 2>&1 &
}

function vskype { # Start skype
	ps -ef | grep s[k]ype | awk '{printf("kill %s\n", $2);}' | bash
	skype >/dev/null 2>&1 &
}

function vstart_im_mail_notes {
	vthunderbird; vpidgin #; vgnote; vskype
}

function vstart_dev_tools {
	eclipse
	firefox &
	geany &
	nautilus ~ &
	menu.sh
	#cd ~/iknow/git/iknow/iknow-ws
	cd ~/tv2/scm/dataflow/spikes
}

function voel { # Start Oracle Enterprise linux in VirtualBox
	virtualbox --startvm "Oracle Developer Days" &
}

function vmule { # Start MuleStudio and mule server
	xterm -e mule &
    firefox http://localhost:8585/mmc &
    firefox http://localhost:8084/MyMessage  &
    (cd ~/opt/MuleStudio/  ;   ./MuleStudio &)
}

function vnetconfig { # Alter resolv.conf after connecting to admin
	cat /etc/resolv.conf
	sudo cp ~/bin/resolv.conf /etc/resolv.conf
	cat /etc/resolv.conf
}

function vqpurge { # Purge named queue
	$IMQ_HOME/bin/imqcmd purge dst -u admin -t q -n $1 <<<admin
}

function vqquery { # Query named queue
	$IMQ_HOME/bin/imqcmd query dst -u admin -t q -n $1 <<<admin
}

function vstart_my_programs { # Daily program startup
	vstart_im_mail_notes && vstart_dev_tools
}

function vrinst {
	#scp -r /home/einar/iknow/svn/dojoandrest/target/test-classes/org/einarvalen/poc/dojoandrest/mq/netty/* /home/einar/iknow/svn/dojoandrest/target/classes/org/einarvalen/poc/dojoandrest/mq/netty/* dsadm@172.30.30.108:/opt/Intelcom/iKnow.3.0/manager/bin/classes/org/einarvalen/poc/dojoandrest/mq/netty
	scp -r /home/einar/iknow/svn/dojoandrest/target/test-classes/no/intelcom/iknow/events/netty/ServerMuckup.class /home/einar/iknow/svn/dojoandrest/target/classes/no/intelcom/iknow/events/netty/* dsadm@172.30.30.108:/opt/Intelcom/iKnow.3.0/manager/bin/classes/no/intelcom/iknow/events/netty/
}

function xsdFromXml {
	trang $1 $2
}

function vgl { # Start/stop Glassfish app server
	if [ "$1" = "u" ]; then
		~/opt/glassfish3/glassfish/bin/asadmin start-domain
	elif [ "$1" = "d" ]; then
		~/opt/glassfish3/glassfish/bin/asadmin stop-domain
	else
		echo vgl u|d  => u=start, d=stop Glassfish
	fi
}

function vls { # Start/stop Lightstreamer server
	if [ "$1" = "u" ]; then
		#xterm -e (cd $LIGHTSTREAMER_HOME/bin/unix-like; ./start.sh) &
		(cd $LIGHTSTREAMER_HOME/bin/unix-like; ./start.sh >/tmp/lightstreamer.log  2>&1 &)
	elif [ "$1" = "d" ]; then
		(cd $LIGHTSTREAMER_HOME/bin/unix-like; ./stop.sh)
	else
		echo vls u|d  => u=start, d=stop Lightstreamer
	fi
}


function vlog {  # Less glassfish log
	 less  ~/opt/glassfish3/glassfish/domains/domain1/logs/server.log
}

function vdepl {  # Deploy war to glassfish
	 cp ./target/*.war ~/opt/glassfish3/glassfish/domains/domain1/autodeploy/
}

function vmk {  # make
	make $@ 2>&1 | tee /tmp/vmk.log
}

alias vst=vstart_my_programs
alias vqlist="$IMQ_HOME/bin/imqcmd list dst -u admin <<<admin"
alias vfo=gnome-open
alias vmnu="menu.py &"
alias vproto="mvn clean install jetty:run"
alias jack="ack-grep --type=java"
alias cack="ack-grep --type=cpp"
alias xack="ack-grep --type=xml"
alias ack="ack-grep --type=cpp"
alias vas="apt-cache search"

PS1='\u@\h->\W\$ '
