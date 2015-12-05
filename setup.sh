#!/bin/sh

cp -f .bashrc $HOME/.bashrc
if [ ! -d $HOME/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
cp -f .vimrc $HOME/.vimrc
cp -f .Xresources $HOME/.Xresources
if [ ! -d $HOME/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
cp -f .tmux.conf $HOME/.tmux.conf
cp -f .emacs $HOME/.emacs
