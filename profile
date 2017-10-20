# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# those parts of the config that are not committed to repo.
# EMACS_USER_CONFIG_DIRECTORY, DEFAULT_WIFI_CONNECTION, SWANK_PORT
# SHELL_CONFIG_DIRECTORY
if [ -f ~/.localrc ]; then
    . ~/.localrc
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# We assume we are using 'st', and colors work better if we are using
# the envvar as it is set below
TERMTYPE="xterm-256color"
if [[ $TERM != $TERMTYPE ]]; then
    export TERM=$TERMTYPE;
fi

# Set things up unless we have done so already. Most of the daemons
# started are above the level of one interactive shell.
if [[ -z $PROFILE_LOADED ]]; then
    # We assume success upfront
    export PROFILE_LOADED=true;

    # wifi if a default is set
    if [ -n $DEFAULT_SSID ]; then
        nmcli connection up $DEFAULT_SSID
    fi

    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/bin" ] ; then
        PATH="$HOME/bin:$PATH"
    fi

    if [ -d "$HOME/.scripts" ] ; then
        PATH="$HOME/.scripts:$PATH"
    fi
    
    # start SBCL in a detached session
    if pgrep sbcl > /dev/null 2>&1
    then
        echo "SBCL:  $(pidof sbcl)"
    else
        screen -dm -S "sbcl.swank" bash -c "sbcl"
    fi

    # start emacs daemon in a detached session
    if pgrep emacs > /dev/null 2>&1
    then
        echo "EMACS: $(pidof emacs)"
    else
        $(LANG="ja-JP.UTF-8" emacs --daemon)
    fi

    # start X
    if pgrep Xorg > /dev/null 2>&1
    then
        echo "XORG:  $(pidof Xorg)"
    else
        startx
    fi
fi
