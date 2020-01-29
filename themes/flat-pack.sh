#!/bin/bash
#Thanks to @dani_ruiz24, https://drasite.com/flat-remix for all of this!
# 
#Make sure to install Gnome tweak tools and enable user themes before running.
#Built & used with Ubuntu 18.04
#

#### EDIT HERE TO CHANGE THEME SETTINGS #####
LOCK_SCREEN_IMG="1080p/Colored Smoke.jpeg"
ICON_THEME="Flat-Remix-Blue-Dark"
APP_THEME="Flat-Remix-GTK-Blue-Dark"
SHELL_THEME="Flat-Remix-Dark-fullPanel"
############################################

shellExChk=$(dpkg -l | grep gnome-shell-extensions)
if [ -z "$shellExChk" ]; then
    echo "You need to install and enable gnome shell extensions!"
    echo "run:  apt install gnome-shell-extensions "
    echo ""
    echo "**Reminder** Logout & login required after install."
    exit 1 
fi

ICON_REPO="https://github.com/daniruiz/flat-remix.git"
THEME_REPO="https://github.com/daniruiz/flat-remix-gtk.git"
SHELL_REPO="https://github.com/daniruiz/flat-remix-gnome.git"

THEME_GIT_DIR="${HOME}/.themeData"
ICON_DIR="icon"
THEME_DIR="theme"
SHELL_DIR="shell"

function clone_or_pull() {
    echo "Pulling/cloning for $1..."
    TMP_PATH="${THEME_GIT_DIR}/${1}"
    mkdir -p ${TMP_PATH}

    if [ ! -d "${TMP_PATH}/.git"  ]; then
        git clone ${2} ${TMP_PATH} > /dev/null
        if [ $? -ne 0 ]; then
            echo "Git clone failed!"
            exit 1
        fi
    else
        pushd ${TMP_PATH} > /dev/null
        git pull > /dev/null
        if [ $? -ne 0 ]; then
            echo "Git pull failed!"
            exit 1
        fi
        popd > /dev/null
    fi
}

clone_or_pull $ICON_DIR $ICON_REPO
clone_or_pull $THEME_DIR $THEME_REPO
clone_or_pull $SHELL_DIR $SHELL_REPO
echo "~={ Git operations complete }=~"

mkdir -p $HOME/.icons
mkdir -p $HOME/.themes

ln -sfn $THEME_GIT_DIR/$ICON_DIR/Flat-Remix-Blue -t $HOME/.icons
ln -sfn $THEME_GIT_DIR/$ICON_DIR/Flat-Remix-Blue-Dark -t $HOME/.icons

ln -sfn $THEME_GIT_DIR/$SHELL_DIR/Flat-Remix-Darkest-fullPanel -t $HOME/.themes
ln -sfn $THEME_GIT_DIR/$SHELL_DIR/Flat-Remix-Darkest -t $HOME/.themes
ln -sfn $THEME_GIT_DIR/$SHELL_DIR/Flat-Remix-Dark-fullPanel -t $HOME/.themes
ln -sfn $THEME_GIT_DIR/$SHELL_DIR/Flat-Remix-Dark -t $HOME/.themes

ln -sfn $THEME_GIT_DIR/$THEME_DIR/Flat-Remix-GTK-Blue-Dark -t $HOME/.themes
ln -sfn $THEME_GIT_DIR/$THEME_DIR/Flat-Remix-GTK-Blue-Dark-Solid -t $HOME/.themes
ln -sfn $THEME_GIT_DIR/$THEME_DIR/Flat-Remix-GTK-Blue-Darkest -t $HOME/.themes
ln -sfn $THEME_GIT_DIR/$THEME_DIR/Flat-Remix-GTK-Blue-Darkest-NoBorder -t $HOME/.themes
ln -sfn $THEME_GIT_DIR/$THEME_DIR/Flat-Remix-GTK-Blue-Darkest-Solid -t $HOME/.themes
ln -sfn $THEME_GIT_DIR/$THEME_DIR/Flat-Remix-GTK-Blue-Darkest-Solid-NoBorder -t $HOME/.themes

gsettings set org.gnome.desktop.interface icon-theme ${ICON_THEME}
gsettings set org.gnome.shell.extensions.user-theme name ${SHELL_THEME}
gsettings set org.gnome.desktop.interface gtk-theme ${APP_THEME}
echo "~={ Theme operations complete }=~"

ln -sf "$HOME/src/linuxGear/images/${LOCK_SCREEN_IMG}" $THEME_GIT_DIR/$THEME_DIR/lockscreen.jpeg 
gsettings set org.gnome.desktop.screensaver picture-uri "file://$THEME_GIT_DIR/$THEME_DIR/lockscreen.jpeg"
echo "~={ Lock screen operations complete }=~"


