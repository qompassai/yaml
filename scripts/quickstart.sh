#!/bin/sh
# /qompassai/yaml/scripts/quickstart.sh
# Qompass AI YAML Quickstart Script
# Copyright (C) 2025 Qompass AI, All rights reserved
####################################################
set -eu
IFS='
'
case "$(uname -s)" in
Linux*) OS=linux ;;
Darwin*) OS=mac ;;
CYGWIN* | MINGW* | MSYS*) OS=windows ;;
*) OS=unknown ;;
esac
case "$OS" in
windows)
        USERPROFILE="${USERPROFILE:-$HOME}"
        XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$USERPROFILE/.config}"
        LOCAL_PREFIX="$USERPROFILE/.local"
        ;;
*)
        XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
        LOCAL_PREFIX="$HOME/.local"
        ;;
esac
BIN_DIR="$LOCAL_PREFIX/bin"
LIB_DIR="$LOCAL_PREFIX/lib"
SHARE_DIR="$LOCAL_PREFIX/share"
SRC_DIR="$LOCAL_PREFIX/src/yaml"
mkdir -p "$BIN_DIR" "$LIB_DIR" "$SHARE_DIR" "$SRC_DIR" "$XDG_CONFIG_HOME/yaml"
case ":$PATH:" in
*":$BIN_DIR:"*) ;;
*) export PATH="$BIN_DIR:$PATH" ;;
esac
detect_arch() {
        case "$(uname -m)" in
        x86_64 | amd64) echo "x86_64" ;;
        aarch64 | arm64) echo "aarch64" ;;
        armv7l | armv8* | arm*) echo "arm" ;;
        riscv64*) echo "riscv64" ;;
        *) echo "unknown" ;;
        esac
}
ARCH="$(detect_arch)"
echo '╭────────────────────────────────────────────╮'
echo '│     Qompass AI · YAML Quick‑Start          │'
echo '╰────────────────────────────────────────────╯'
echo '  © 2025 Qompass AI. All rights reserved'
echo
echo "Detected OS:    $OS"
echo "Detected Arch:  $ARCH"
echo
echo "Core YAML tools will be installed to $LOCAL_PREFIX/{bin,lib,share}"
echo
echo "→ Installing yq (YAML CLI processor)..."
case "$OS" in
linux | mac)
        YQ_URL=""
        case "$ARCH" in
        x86_64) YQ_URL="https://github.com/mikefarah/yq/releases/latest/download/yq_${OS}_amd64" ;;
        aarch64) YQ_URL="https://github.com/mikefarah/yq/releases/latest/download/yq_${OS}_arm64" ;;
        arm) YQ_URL="https://github.com/mikefarah/yq/releases/latest/download/yq_${OS}_arm" ;;
        riscv64) YQ_URL="" ;; # yq does not provide riscv; fallback to pip/pipx
        esac
        if [ -n "$YQ_URL" ]; then
                curl -fsSL "$YQ_URL" -o "$BIN_DIR/yq"
                chmod +x "$BIN_DIR/yq"
        else
                PY_CMD="$(command -v python3 || command -v python)"
                if [ -n "$PY_CMD" ]; then
                        "$PY_CMD" -m pip install --user yq || :
                fi
        fi
        ;;
windows)
        YQ_URL="https://github.com/mikefarah/yq/releases/latest/download/yq_windows_amd64.exe"
        curl -fsSL "$YQ_URL" -o "$BIN_DIR/yq.exe"
        ;;
*)
        echo "Unsupported or unknown OS!"
        exit 1
        ;;
esac
echo "→ Installing yamllint (YAML linter, via pip)..."
PY_CMD="$(command -v python3 || command -v python)"
if [ -n "$PY_CMD" ]; then
        "$PY_CMD" -m pip install --user yamllint
else
        echo "Python not found; yamllint install skipped."
fi
echo
printf "Do you want to install \033[1mYAML Language Server (yaml-language-server)\033[0m for VSCode/protocol support? [Y/n]: "
read -r ans
[ -z "$ans" ] && ans="Y"
if [ "$ans" = "Y" ] || [ "$ans" = "y" ]; then
        # Try to install with npm, pipx, or portable binary
        if command -v npm >/dev/null 2>&1; then
                npm install -g yaml-language-server
        elif command -v pipx >/dev/null 2>&1; then
                pipx install yaml-language-server
        else
                echo "Neither npm nor pipx found; you can install yaml-language-server manually if desired."
        fi
fi
add_path_to_shell_rc() {
        rcfile=$1
        line="export PATH=\"$BIN_DIR:\$PATH\""
        if [ -f "$rcfile" ]; then
                if ! grep -Fxq "$line" "$rcfile"; then
                        printf '\n# Added by Qompass AI YAML quickstart script\n%s\n' "$line" >>"$rcfile"
                        echo " → Added PATH export to $rcfile"
                fi
        fi
}
add_path_to_shell_rc "$HOME/.bashrc"
add_path_to_shell_rc "$HOME/.zshrc"
add_path_to_shell_rc "$HOME/.profile"
create_xdg_config() {
        tool="$1"
        default_content="$2"
        confdir="$XDG_CONFIG_HOME/$tool"
        confpath="$confdir/config.yaml"
        mkdir -p "$confdir"
        if [ -f "$confpath" ]; then
                echo "→ $tool config already exists at $confpath"
                return
        fi
        printf "Do you want to write an example config for $tool to %s? [Y/n]: " "$confpath"
        read -r ans
        [ -z "$ans" ] && ans="Y"
        if [ "$ans" = "Y" ] || [ "$ans" = "y" ]; then
                echo "→ Creating example $tool config at $confpath"
                printf "%s\n" "$default_content" >"$confpath"
        fi
}
YAMLINT_CFG="rules:\n  line-length:\n    max: 120\n    level: warning\n"
YQ_CFG="# Add yq config options here\n"
LSP_CFG="yaml:\n  schemas: {}\n  validate: true\n"
create_xdg_config "yamllint" "$YAMLINT_CFG"
create_xdg_config "yq" "$YQ_CFG"
create_xdg_config "yaml-language-server" "$LSP_CFG"
echo
echo "✅ YAML tools have been installed in $BIN_DIR"
echo "→ Test yq with:      yq --version"
echo "→ Test yamllint with: yamllint --version"
echo "→ All configs placed in $XDG_CONFIG_HOME/"
echo "→ All user binaries/libs/configs are under ~/.local/, ~/.config/"
echo "→ To uninstall, just rm -rf $LOCAL_PREFIX/{bin,lib,share} $SRC_DIR $XDG_CONFIG_HOME/yamllint $XDG_CONFIG_HOME/yq $XDG_CONFIG_HOME/yaml-language-server"
echo "─ Ready, Set, YAML! ─"
exit 0
