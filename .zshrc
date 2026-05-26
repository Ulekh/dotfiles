# --- Performance Optimization ---
# Load zsh hooks early
autoload -Uz add-zsh-hook

# --- PATH & Environment ---
export ZSH="$HOME/.oh-my-zsh"
[ -f ~/.env.zsh ] && source ~/.env.zsh

# Path to your local bin
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Go
export PATH="$PATH:$HOME/.local/opt/go/bin"

# Language
export LANGUAGE='en_US.UTF-8 git'
export LANG=en_US.UTF-8

# --- Oh My Zsh Configuration ---
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"
CASE_SENSITIVE="false"
ENABLE_CORRECTION="true"

zstyle ':omz:update' frequency 13

# --- Plugins ---
# Note: zsh-autosuggestions and zsh-syntax-highlighting should be at the END of the list
plugins=(
    git
    copypath
    fzf
    zsh-interactive-cd
    tmux
    zsh-completions
    fzf-tab
)

source $ZSH/oh-my-zsh.sh

# --- Custom Plugins / Manual Sourcing ---
# These should be sourced AFTER oh-my-zsh.sh
[ -f ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Use Up/Down arrows to search through history for commands starting with what you've typed
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will handle them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the request
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group ',' '.'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="50"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# --- Tool Lazy Loading (NVM, Bun, etc.) ---
export NVM_DIR="$HOME/.nvm"
[ -f ~/.zsh/nvm_lazy.zsh ] && source ~/.zsh/nvm_lazy.zsh

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory
setopt sharehistory          # Share history between different instances of zsh
setopt hist_ignore_dups      # Ignore successive duplicate entries
setopt hist_ignore_all_dups  # If a new command is a duplicate, remove the older one
setopt hist_ignore_space     # Don't record an entry starting with a space
setopt hist_reduce_blanks    # Remove superfluous blanks before recording to history
setopt hist_verify           # Don't execute immediately upon history expansion

# --- FZF Configuration ---
# Set up fzf key binding and fuzzy completion
source <(fzf --zsh)

# Use fd instead of find for fzf (faster and respects .gitignore)
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Better FZF history search (CTRL-R)
# --sort ensures the most relevant matches are on top
# --height and --layout make it look better
export FZF_CTRL_R_OPTS="--sort --height 40% --layout=reverse --border --inline-info"

# --- Aliases ---
alias zed="open -a /Applications/Zed.app -n"
alias idea="open -na WebStorm.app"
alias fcode='code $(fzf -m --preview="bat --color=always {}")'
alias vlcdl='download_video'
alias compressVid='ffcomp' # Corrected to use your function
alias pip=pip3

# Modern CLI tools aliases
alias ls="eza --icons=always"
alias ll="eza -lh --icons=always --git"
alias la="eza -lah --icons=always --git"
alias lt="eza --tree --level=2 --icons=always"
alias cat="bat"

# --- Help & Cheatsheets ---
# Usage: cheat <command>
function cheat() {
    curl -s "https://cht.sh/$1" | less -R
}

# --- Functions ---
# download m3u8 from youtube/patreon
function download_video() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: download_video <YouTube URL> <output filename>"
        return 1
    fi
    vlc -vvv "$1" --sout=file/mp4:"$2"
}

# compress video using ffmpeg
ffcomp() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: ffcomp input.mp4 output.mp4"
        return 1
    fi
    ffmpeg -i "$1" -vcodec libx264 -crf 28 -preset faster "$2"
}

# --- Bun Completions ---
[ -s "/Users/olegbordun/.bun/_bun" ] && source "/Users/olegbordun/.bun/_bun"

# --- Modern Tools Init ---
eval "$(zoxide init zsh)"

# --- Starship (Prompt) ---
# Should be near the end
eval "$(starship init zsh)"

# --- External Loaders ---
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Auto-ls on directory change
function _auto_ls_on_cd() {
    # Only run if we are in an interactive shell and not in a quiet mode
    if [[ -n "$PS1" ]]; then
        echo ""
        ll # Uses your existing eza alias
    fi
}

add-zsh-hook chpwd _auto_ls_on_cd

# --- Smart Tab Override ---
# Must be at the very end to ensure it overrides fzf's Tab bindings
function _smart_tab() {
  if [[ -n "$POSTDISPLAY" ]]; then
    zle autosuggest-accept
  else
    zle expand-or-complete
  fi
}
zle -N _smart_tab
bindkey '^I' _smart_tab
