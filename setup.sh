#!/bin/bash

echo " ***** Welcome to your ubuntu setup! ***** "

dev_path="$HOME/t1"
themes_path="$HOME/.themes"
icons_path="$HOME/.icons"
extensions_path="$HOME/.local/share/gnome-shell/extensions"

function create_directory_if_not_exists() {
    if [ -d "$1" ] 
    then
        echo "Directory $1 already exists." 
    else
        echo "Creating: Directory $1 does not exists."
        mkdir "$1"
    fi
}

function delete_file_if_exists () {
    if [ -f "$1" ] 
    then
        echo "Deleting: File $1 exists"
        sudo rm "$1" 
    else
        echo "File $1 does not exists."
    fi
}

function delete_directory_if_exists () {
    if [ -d "$1" ] 
    then
        echo "Deleting: Directory $1 exists"
        sudo rm -R "$1" 
    else
        echo "Directory $1 does not exists."
    fi
}

function basic_setup() {
    echo 'Doing basic setup';

	sudo apt-get upgrade
	sudo apt-get install curl make wget
}

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

    ssh -T git@github.comkillall -3 gnome-shell
}

function install_extension() {
    url="https://extensions.gnome.org/extension-data"
    echo "Installing extension $1"

    delete_file_if_exists "$1"
    wget "$url/$1"

    export fuuid=$(unzip -c "$1" metadata.json | grep uuid | cut -d \" -f4)
    echo "$fuuid"

    if [ -d "$extensions_path/$fuuid" ] 
    then
        echo "Extension $fuuid already exists." 
    else
        echo "Creating: Extenison $fuuid does not exists."
        create_directory_if_not_exists "$extensions_path/$fuuid"
        unzip -q "$1" -d "$extensions_path/$fuuid/"
    fi

    gnome-shell-extension-tool -e "$fuuid"

    delete_file_if_exists "$1"
}

function setup_themes() {
    echo 'hello, setting up themes';

    # sudo apt-get install gnome-tweaks gnome-shell-extensions wget

    # checking if dev folder exists or not
    # create_directory_if_not_exists "$dev_path"
    # delete_directory_if_exists "$dev_path/my-ubuntu-setup"

    # cd "$dev_path" && git clone git@github.com:Signior-X/my-ubuntu-setup.git

    # create_directory_if_not_exists "$themes_path"

    # delete_directory_if_exists "$themes_path/Layan-dark"
    # cp -R "$dev_path/my-ubuntu-setup/themes/Layan-dark" "$themes_path/Layan-dark"

    # delete_directory_if_exists "$themes_path/Layan-light"
    # cp -R "$dev_path/my-ubuntu-setup/themes/Layan-light" "$themes_path/Layan-light"

    # gsettings set org.gnome.desktop.interface gtk-theme "Layan-dark"
    # echo "Gtk theme set to layan light"

    # create_directory_if_not_exists "$icons_path"

    # delete_directory_if_exists "$icons_path/candy-icons"
    # cp -R "$dev_path/my-ubuntu-setup/icons/candy-icons" "$icons_path/candy-icons"

    # gsettings set org.gnome.desktop.interface icon-theme "candy-icons"
    # echo "Icons set to candy icons!"

    # gsettings set org.gnome.shell.extensions.user-theme name "Layan-dark"
    # echo "User theme set to layan-light"

    install_extension "gnome-shell-screenshotttll.de.v43.shell-extension.zip"
    install_extension "clipboard-indicatortudmotu.com.v34.shell-extension.zip"
    install_extension "night-light-slider.timurlinux.com.v12.shell-extension.zip"
    install_extension "hidetopbarmathieu.bidon.ca.v72.shell-extension.zip"
    install_extension "unitehardpixel.eu.v32.shell-extension.zip"
}

# sudo apt-get update

# while true; do
#     read -p "Do you wish to install basic utilites? " yn
#     case $yn in
#         [Nn]* ) break;;
#         * ) basic_setup; break;;
#     esac
# done


# while true; do
#     read -p "Do you wish to setup git with ssh? " yn
#     case $yn in
#         [Nn]* ) break;;
#         * ) setup_git; break;;
#     esac
# done

while true; do
    read -p "Do you wish setup themes " yn
    case $yn in
        [Nn]* ) break;;
        * ) setup_themes; break;;
    esac
done
