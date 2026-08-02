# Changelog

All notable changes to this dotfiles repository will be documented in this file.

---

## [2026-08-02] - NPM Completion & Tab Binding Fix

### Added
- **Static NPM Completions (`.zsh/_npm_completion`)**: Added a pre-generated `npm completion` script to enable fast, lightweight subcommand and flag autocompletion without slowing down terminal startup time.
- **Symlink Automation (`install.sh`)**: Updated `install.sh` to link `.zsh/_npm_completion` into `$HOME/.zsh/_npm_completion`.

### Changed
- **Fixed Tab Key Behavior (`.zshrc`)**: Removed the custom `_smart_tab` override function.
  - **Problem**: Previously, pressing `Tab` while a history autosuggestion was visible (from `zsh-autosuggestions`) would accept the historical command instead of displaying parameter autocompletion.
  - **Solution & Workflow**:
    - `Tab` now exclusively opens interactive parameter and subcommand completions using `fzf-tab`.
    - History autosuggestions (ghost text) can still be accepted with the Right Arrow (`→`) key or `Ctrl+F`.
    - History search remains accessible via `Ctrl+R`.
