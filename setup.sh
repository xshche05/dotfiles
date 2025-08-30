#!/bin/bash

emacs=0
git=0

for opt in "$@"; do

    # Create a symlinks for Emacs files
    if [ "$opt" = "--emacs" ]; then
        for emacs_conf_file_rel in ./.emacs.d/*.el; do
            emacs_conf_file=$(realpath "$emacs_conf_file_rel")
            file_name=$(basename "$emacs_conf_file")
            echo "Linking $HOME/.emacs.d/$file_name to $file_name"
            ln -fs "$emacs_conf_file" "$HOME/.emacs.d/$file_name"
            emacs=1
        done
    fi

    # Create symlink for Git files
    if [ "$opt" = "--git" ]; then
        git_conf_file=$(realpath "./.gitconfig")
        file_name=$(basename "$git_conf_file")
        echo "Linking $HOME/$file_name to $file_name"
        ln -fs "$git_conf_file" "$HOME/$file_name"
        git=1
    fi

done


if (( $emacs == 0 )); then
    echo "Skipping the Emacs config setup... (--emacs)"
else
    echo "Emacs config setup is completed"
fi

if (( $git == 0 )); then
    echo "Skipping the Git config setup... (--git)"
else
    echo "Git config setup is completed"
fi
