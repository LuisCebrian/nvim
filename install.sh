#!/bin/bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

movenewnvim() {
    echo "Moving your config to nvim.old"
    cp -r . $HOME/.config/nvim
}

moveoldnvim() { \
    echo "Moving your config to nvim.old"
    mv $HOME/.config/nvim $HOME/.config/nvim.old
}

# Move old nvim config if it exists
[ -d "$HOME/.config/nvim" ] && moveoldnvim

# Copy this config 
movenewnvim
