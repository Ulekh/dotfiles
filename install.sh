#!/bin/zsh

# Define the dotfiles directory
DOTFILES_DIR="$HOME/workspace/github.com/dotfiles"

# List of files/folders to link
# Format: "source_in_repo:target_in_home"
files=(
    ".zshrc:$HOME/.zshrc"
    ".tmux.conf:$HOME/.tmux.conf"
    ".tmux/themes:$HOME/.tmux/themes"
    ".local/bin/tmux-sync-theme:$HOME/.local/bin/tmux-sync-theme"
    ".config/starship.toml:$HOME/.config/starship.toml"
    ".zsh/nvm_lazy.zsh:$HOME/.zsh/nvm_lazy.zsh"
)

echo "Setting up symbolic links..."

for entry in "${files[@]}"; do
    repo_path="${DOTFILES_DIR}/${entry%%:*}"
    home_path="${entry#*:}"

    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$home_path")"

    # If the home file exists and is NOT a symlink, back it up
    if [[ -f "$home_path" || -d "$home_path" ]] && [[ ! -L "$home_path" ]]; then
        echo "Backing up existing $home_path to ${home_path}.bak"
        mv "$home_path" "${home_path}.bak"
    fi

    # Create the symbolic link
    echo "Linking $home_path -> $repo_path"
    ln -sf "$repo_path" "$home_path"
done

echo "Done! Your dotfiles are now managed by symlinks."
