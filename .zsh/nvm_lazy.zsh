# --- Tool Lazy Loading (NVM, Bun, etc.) ---
# This file is sourced in ~/.zshrc

__load-nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

__work() {
    for label in "${__lazyLoadLabels[@]}"; do
        unset -f "$label" 2>/dev/null
    done
    unset -v __lazyLoadLabels
    __load-nvm
    unset -f __load-nvm __work
}

typeset -ga __lazyLoadLabels=(
    bun
    bunx
    node
    npm
    npx
    nvm
    pnpm
    pnpx
    turbo
    typescript-language-server
    yarn
    gemini
    claude
    corepack
)

# Automatically add all global NVM binaries
if [ -d "$NVM_DIR/versions/node" ]; then
    for _nvm_bin_dir in "$NVM_DIR"/versions/node/*/bin; do
        if [ -d "$_nvm_bin_dir" ]; then
            __lazyLoadLabels+=($(ls "$_nvm_bin_dir"))
        fi
    done
fi

# Unique labels only
__lazyLoadLabels=(${(u)__lazyLoadLabels})

for label in "${__lazyLoadLabels[@]}"; do
    if ! whence "$label" > /dev/null; then
        eval "$label() { __work; \$0 \"\$@\"; }"
    fi
done
unset _nvm_bin_dir
