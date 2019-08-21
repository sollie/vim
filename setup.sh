#!/bin/sh

mkdir ~/.vim/backup
mkdir ~/.vim/autoload
mkdir ~/.vim/swap
mkdir ~/.vim/undo

vim -c "execute \"PlugInstall --sync\" | qa"
