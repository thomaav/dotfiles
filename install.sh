#!/bin/sh
set -e

symlink()
{
    dst="$HOME/$2"
    src="$PWD/$1"

    if [ -e "$dst" ]; then
	echo "$dst exists, continuing"
    else
	ln -s -v "$src" "$dst"
    fi
}

echo "Installing dotfiles.."

symlink "emacs/.emacs" ".emacs"
symlink "git/.gitconfig" ".gitconfig"
symlink "tmux/.tmux.conf" ".tmux.conf"
