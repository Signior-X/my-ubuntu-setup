#!/bin/bash

echo " ***** Welcome to your ubuntu setup! ***** "

dev_path="$HOME/t1"
themes_path="$HOME/.themes"
icons_path="$HOME/.icons"
extensions_path="$HOME/.local/share/gnome-shell/extensions"

node_version=16

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
    read -p 'Add this ssh key in your github account visiting https://github.com/settings/keys and Press enter ' tmpvr

    ssh -T git@github.comkillall -3 gnome-shell
    echo "Git complete if previous message was success"
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

    sudo apt-get install gnome-tweaks gnome-shell-extensions wget

    # checking if dev folder exists or not
    create_directory_if_not_exists "$dev_path"
    delete_directory_if_exists "$dev_path/my-ubuntu-setup"

    cd "$dev_path" && git clone git@github.com:Signior-X/my-ubuntu-setup.git

    create_directory_if_not_exists "$themes_path"

    delete_directory_if_exists "$themes_path/Layan-dark"
    cp -R "$dev_path/my-ubuntu-setup/themes/Layan-dark" "$themes_path/Layan-dark"

    delete_directory_if_exists "$themes_path/Layan-light"
    cp -R "$dev_path/my-ubuntu-setup/themes/Layan-light" "$themes_path/Layan-light"

    gsettings set org.gnome.desktop.interface gtk-theme "Layan-light"
    echo "Gtk theme set to layan light"

    create_directory_if_not_exists "$icons_path"

    delete_directory_if_exists "$icons_path/candy-icons"
    cp -R "$dev_path/my-ubuntu-setup/icons/candy-icons" "$icons_path/candy-icons"

    gsettings set org.gnome.desktop.interface icon-theme "candy-icons"
    echo "Icons set to candy icons!"

    gsettings set org.gnome.shell.extensions.user-theme name "Layan-light"
    echo "User theme set to layan-light"

    install_extension "gnome-shell-screenshotttll.de.v43.shell-extension.zip"
    install_extension "clipboard-indicatortudmotu.com.v34.shell-extension.zip"
    install_extension "night-light-slider.timurlinux.com.v12.shell-extension.zip"
    install_extension "hidetopbarmathieu.bidon.ca.v72.shell-extension.zip"
    install_extension "unitehardpixel.eu.v32.shell-extension.zip"
}

function setup_conda() {
    sudo apt-get install wget

    delete_file_if_exists "Miniconda3-latest-Linux-x86_64.sh"
    wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    bash Miniconda3-latest-Linux-x86_64.sh

    # delete_file_if_exists "Miniconda3-latest-Linux-x86_64.sh"
}

function setup_node() {
    sudo apt-get install curl

    curl -fsSL "https://deb.nodesource.com/setup_$node_version.x" | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "Node.js installed"
}

function setup_opera_chrome() {
    wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -

    sudo add-apt-repository "deb [arch=i386,amd64] https://deb.opera.com/opera-stable/ stable non-free"
    sudo apt install opera-stable
    echo "Opera installed"

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
    sudo apt-get update 
    sudo apt-get install google-chrome-stable
    echo "Chrome installed"
}

function setup_vscode() {
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg

    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code
    echo "VS code installed"
}

function setup_rest_all {
    # Heroku
    sudo wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    echo "Heroku Installed"

    # sublime text
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt-get install apt-transport-https
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install sublime-text

    echo "Sublime text installed - Don't forget to setup build script :P"
}

function setup_flutter() {
    sudo snap install flutter

    # For android studio, do manually
}

function setup_priyam() {
    setup_conda
    setup_node
    setup_opera_chrome
    setup_vscode
    setup_rest_all
    setup_flutter
}


sudo apt-get update

while true; do
    read -p "Do you wish to install basic utilites? " yn
    case $yn in
        [Nn]* ) break;;
        * ) basic_setup; break;;
    esac
done


while true; do
    read -p "Do you wish to setup git with ssh? " yn
    case $yn in
        [Nn]* ) break;;
        * ) setup_git; break;;
    esac
done

while true; do
    read -p "Do you wish setup themes? " yn
    case $yn in
        [Nn]* ) break;;
        * ) setup_themes; break;;
    esac
done

while true; do
    read -p "Do you wish to install all that what priyam uses? " yn
    case $yn in
        [Nn]* ) break;;
        * ) setup_priyam; break;;
    esac
done
