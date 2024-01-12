#
# Author: Ash <tuxdude.io@gmail.com>
#

# Run git in multiple repos at the same level
gitmulti() {
    for dir in $(find . -maxdepth 2 -name .git | xargs dirname); do cd $dir && pwd && git $@ && echo && cd - > /dev/null; done
}

# This is the location where the git scripts repository will be checked out.
export GIT_SCRIPTS_DIR="/data/dev-stuff/git-repos/git-scripts"

# The URI of the git-scripts repository.
export GIT_SCRIPTS_REPO="github:Tuxdude/git-scripts"

# The symlinks to create.
export GIT_SCRIPTS_SYMLINKS=("git-fetch-and-rebase" "git-forest" "git-wtf")

export GIT_SCRIPTS_BASE_DIR="$(dirname $GIT_SCRIPTS_DIR)"

# List the git repository URLs, for the git scripts repositories.
git_scripts_list_repo_urls() {
    git -C "$GIT_SCRIPTS_DIR" config remote.origin.url
}

git_scripts_get_repos() {
    if [ -n "$ADDON_GIT_REPOS_USE_HTTPS_URLS" ]; then
        echo "$GIT_SCRIPTS_REPO" | sed 's/github:/https:\/\/github.com\//g'
    else
        echo "$GIT_SCRIPTS_REPO"
    fi
}

# Download/Update all the git scripts.
git_scripts_update() {
    mkdir -p $(dirname $GIT_SCRIPTS_BASE_DIR)
    for repo in $(git_scripts_get_repos); do
        repoDirName="$(basename $repo)"
        repoFullPath="$GIT_SCRIPTS_BASE_DIR/$repoDirName"
        if [ -d "$repoFullPath" ]; then
            # If the directory already exists, update it
            echo "Trying to update $repo"
            git fetch-and-rebase "$repoFullPath"
        else
            # Else do a fresh clone
            echo "Installing $repo"
            git clone "$repo" "$repoFullPath"
        fi
    done
}

# Create/update the symlinks.
git_scripts_sync_symlinks() {
    mkdir -p ~/.local/bin
    for sym in "${GIT_SCRIPTS_SYMLINKS[@]}"; do
        echo "Symlinking $GIT_SCRIPTS_DIR/$sym -> ~/.local/bin/$sym"
        ln -sf "$GIT_SCRIPTS_DIR/$sym" ~/.local/bin/"$sym"
    done
}

# Use the config file to setup the git scripts repositories, the symlinks and any additional
# installation if required.
git_scripts_setup() {
    git_scripts_sync_symlinks && git_scripts_update
}
