#!/bin/bash

# Entorn pre-install for Ubuntu as host

shopt -s expand_aliases

file="$HOME/.profile"


## ssh aliases
if grep -q "UserKnownHostsFile" "$file"; then
        echo
	echo "ssh alias already set." # String was found
        echo
else
	alias ssh='ssh -o UserKnownHostsFile=/dev/null'
	alias sshfs='sshfs -o UserKnownHostsFile=/dev/null'
        echo "alias ssh='ssh -o UserKnownHostsFile=/dev/null'" >> $file
	echo "alias sshfs='sshfs -o UserKnownHostsFile=/dev/null'" >> $file
        echo "ssh alias is now set."
        echo
fi


## kubectl alias (k)
if grep -q "kubectl" "$file"; then        
	echo "kubectl (k) alias already set." # String was found
        echo
else
        alias k="kubectl --namespace=entorn"
	echo "alias k='kubectl --namespace=entorn'" >> $file
	echo "kubectl (k) alias is now set."
        echo
fi


## DISPLAY env var
if grep -q "DISPLAY" "$HOME/.bashrc"; then	
	echo "DISPLAY already set."
	echo
else	
        echo 'export DISPLAY="`grep nameserver /etc/resolv.conf | sed \"s/nameserver //\"`:0.0"' >> $HOME/.bashrc
	echo "DISPLAY is now set."
	echo
fi

## Make sure PATH is properly set
if grep -q "PATH" "$HOME/.bashrc"; then
        echo "PATH already set."
	echo
else
        cat << 'EOF' >> "$HOME/.bashrc"
# set PATH so it includes user's private bin if it exists 
if [ -d "$HOME/.local/bin" ] ; then 
	export PATH="$HOME/.local/bin:$PATH" 
fi
EOF
        echo "PATH is now set."
        echo
fi

## Dependencies
echo "Installing dependencies ..."
echo
sudo apt install sshpass ssh -y > /dev/null

## Scripts deployment
mkdir -p $HOME/.local/bin

install_script() {
cp ./bin/entorn-$1 $HOME/.local/bin
chmod +x $HOME/.local/bin/entorn-$1
if [ ! -L "$HOME/.local/bin/entorn_$1" ]; then
	ln -s $HOME/.local/bin/entorn-$1 $HOME/.local/bin/entorn_$1
fi
echo "'entorn $1' is now available"
echo
}

install_script mount
install_script umount
install_script restart
install_script stop
install_script start
install_script reset
install_script update
install_script run
install_script ssh
install_script show

cp ./bin/entorn $HOME/.local/bin/
chmod +x $HOME/.local/bin/entorn

cp ./kube-local/config.yaml $HOME/.local/

if [ "$1" ]; then
    exit 0
fi

## Kubernetes deployment
cd ./kube-local/
./install-k8s-entorn.sh


echo "WARNING: You need to open a new terminal for the new env vars to be available."
echo
exit 0

