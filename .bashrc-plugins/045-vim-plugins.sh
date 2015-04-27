
#
# Author: Ash <tuxdude.io@gmail.com>
#

# This is the location where all the vim plugin repositories will be
# checked out
export VIM_PLUGINS_DIR="/data/dev-stuff/git-repos/vim-plugins"

# This is vim's bundle directory
export VIM_BUNDLE_DIR="$HOME/.vim/bundle"

# List the git repository URLs, for all the repositories present
# under a given directory
vim_plugins_list_repo_urls() {
    for dir in "$VIM_BUNDLE_DIR/"*/; do
        if [ -d "$dir/.git" ]; then
            git -C "$dir" config remote.origin.url
        fi
    done
}

# Write the repo info for all the vim plugins to the config file
vim_plugins_config_update() {
    vim_plugins_list_repo_urls | sort -n > ~/.vim/pluginlist.config
}

# Download/Update all the vim plugins
vim_plugins_update() {
    mkdir -p $VIM_PLUGINS_DIR
    for repo in $(cat ~/.vim/pluginlist.config); do
        pluginDirName="$(basename $repo)"
        pluginFullPath="$VIM_PLUGINS_DIR/$pluginDirName"
        if [ -d "$pluginFullPath" ]; then
            # If the directory already exists, update it
            echo "Trying to update $repo"
            git fetch-and-rebase "$pluginFullPath"
        else
            # Else do a fresh clone
            echo "Installing $repo"
            git clone "$repo" "$pluginFullPath"
        fi
    done
}

# Based on the plugins config file, create/update the symlinks
# @ ~/.vim/bundle -> $VIM_PLUGINS_DIR
vim_plugins_sync_symlinks() {
    # Ensure that $VIM_BUNDLE_DIR exists
    mkdir -p $VIM_BUNDLE_DIR

    # First remove all existing symlinks under $VIM_BUNDLE_DIR
    find $VIM_BUNDLE_DIR -maxdepth 1 -type l -print0 | xargs -0 -n 1 rm -f 2> /dev/null || true

    for repo in $(cat ~/.vim/pluginlist.config); do
        pluginDirName="$(basename $repo)"
        if [ -d "$VIM_PLUGINS_DIR/$pluginDirName" ]; then
            echo "Symlinking $VIM_BUNDLE_DIR/$pluginDirName -> $VIM_PLUGINS_DIR/$pluginDirName"
            ln -sf "$VIM_PLUGINS_DIR/$pluginDirName" "$VIM_BUNDLE_DIR/$pluginDirName"
        else
            echo "Warning! Repo not already cloned: $repo"
        fi
    done
}

# Setup the vim YCM plugin if required
# Compiles ycm_core with clang completion and go completion support
# Assumes all the system dependencies have already been installed
vim_plugins_install_ycm() {
    ycm_dir="$VIM_PLUGINS_DIR/YouCompleteMe"
    if [ ! -f "$ycm_dir/third_party/ycmd/ycm_core.so" ]; then
        echo "Setting up clang completion for YCM"
        pushd $VIM_PLUGINS_DIR/YouCompleteMe
        git submodule update --init --recursive
        ./install.sh --clang-completer --system-libclang --gocode-completer
        popd
        echo "Done setting up clang completion for YCM"
    fi
}

# Use the config file to setup the plugins, the symlinks and any additional
# installation if required
vim_plugins_setup() {
    vim_plugins_update && vim_plugins_sync_symlinks && vim_plugins_install_ycm
}
