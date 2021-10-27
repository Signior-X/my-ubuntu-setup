#!/bin/bash

echo " ***** Welcome to your ubuntu setup! ***** "

sudo apt-get update

function basic_setup() {
    echo 'Doing basic setup';

	sudo apt-get upgrade
	sudo apt-get install curl make
}

while true; do
    read -p "Do you wish to install basic utilites? " yn
    case $yn in
        [Nn]* ) break;;
        * ) basic_setup; break;;
    esac
done

function setup_git() {
    echo 'hello, world'

    sudo apt-get install git

    read -p "Enter git user name: " gnm
    git config --global user.name $gnm

    read -p "Enter git user email: " gun
    git config --global user.email $gun

    ssh-keygen -t rsa -C $gun

    echo ''
    echo 'This is the ssh key:'
    cat ~/.ssh/id_rsa.pub

    echo ''
    read -p 'Add this ssh key in your github account and press enter ' tmpvr

    ssh -T git@github.com
}

while true; do
    read -p "Do you wish to setup git with ssh? " yn
    case $yn in
        [Nn]* ) break;;
        * ) setup_git; break;;
    esac
done
