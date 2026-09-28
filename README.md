<!----------/qompassai/yaml/README.md ---------------->
<!-- ----------Qompass AI YAML ----------------------->
<!-- Copyright (C) 2025 Qompass AI, All rights reserved -->
<!-------------------------------------------------------->

<h2> Qompass AI on YAML </h2>

<h3> YAML Ain't Markup Language (YAML): Making configs easy </h3>

![Repository Views](https://komarev.com/ghpvc/?username=qompassai-yaml)
![GitHub all releases](https://img.shields.io/github/downloads/qompassai/yaml/total?style=flat-square)

<p align="center">
  <a href="https://yaml.org/">
  <img src="https://img.shields.io/badge/YAML-000000?style=for-the-badge&logo=yaml&logoColor=white" alt="YAML">
</a>
<br>
<a href="https://yaml.org/spec/1.2.2/">
  <img src="https://img.shields.io/badge/YAML_Specification-blue?style=flat-square" alt="YAML Specification">
</a>
<a href="https://github.com/topics/yaml">
  <img src="https://img.shields.io/badge/YAML_Tutorials-green?style=flat-square" alt="YAML Tutorials">
</a>

<br>
  <a href=\"./LICENSE\"><img src=\"https://img.shields.io/badge/License-Apache%202.0-blue.svg\" alt=\"License: Apache 2.0\"></a>
</p>


<details>
  <summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #667eea; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;">
    <strong>▶️ Qompass AI Quick Start</strong>
  </summary>
  <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin-top: 10px; font-family: monospace;">

```sh  
curl -fsSL https://raw.githubusercontent.com/qompassai/yaml/main/scripts/quickstart.sh | sh
```
  </div>
  <blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #f8f9fa; border-left: 6px solid #667eea; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
    <details>
      <summary style="font-size: 1em; font-weight: bold; padding: 10px; background: #e9ecef; color: #333; border-radius: 5px; cursor: pointer; margin: 10px 0;">
        <strong>📄 We advise you read the script BEFORE running it 😉</strong>
      </summary>
      <pre style="background: #fff; padding: 15px; border-radius: 5px; border: 1px solid #ddd; overflow-x: auto;">
#!/bin/sh
# /qompassai/yaml/scripts/quickstart
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
</pre>
    </details>
    <p>Or, <a href="https://github.com/qompassai/yaml/blob/main/scripts/quickstart.sh" target="_blank">View the quickstart script</a>.</p>
  </blockquote>
</details>

</blockquote>
</details>

<details>
<summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #667eea; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;"><strong>🧭 About Qompass AI</strong></summary>
<blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #f8f9fa; border-left: 6px solid #667eea; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">

<div align="center">
  <p>Matthew A. Porter<br>
  Former Intelligence Officer<br>
  Educator & Learner<br>
  DeepTech Founder & CEO</p>
</div>

<h3>Publications</h3>
  <p>
    <a href="https://orcid.org/0000-0002-0302-4812">
      <img src="https://img.shields.io/badge/ORCID-0000--0002--0302--4812-green?style=flat-square&logo=orcid" alt="ORCID">
    </a>
    <a href="https://www.researchgate.net/profile/Matt-Porter-7">
      <img src="https://img.shields.io/badge/ResearchGate-Open--Research-blue?style=flat-square&logo=researchgate" alt="ResearchGate">
    </a>
    <a href="https://zenodo.org/communities/qompassai">
      <img src="https://img.shields.io/badge/Zenodo-Publications-blue?style=flat-square&logo=zenodo" alt="Zenodo">
    </a>
  </p>

<h3>Developer Programs</h3>

[![NVIDIA Developer](https://img.shields.io/badge/NVIDIA-Developer_Program-76B900?style=for-the-badge\&logo=nvidia\&logoColor=white)](https://developer.nvidia.com/)
[![Meta Developer](https://img.shields.io/badge/Meta-Developer_Program-0668E1?style=for-the-badge\&logo=meta\&logoColor=white)](https://developers.facebook.com/)
[![HackerOne](https://img.shields.io/badge/-HackerOne-%23494649?style=for-the-badge\&logo=hackerone\&logoColor=white)](https://hackerone.com/phaedrusflow)
[![HuggingFace](https://img.shields.io/badge/HuggingFace-qompass-yellow?style=flat-square\&logo=huggingface)](https://huggingface.co/qompass)
[![Epic Games Developer](https://img.shields.io/badge/Epic_Games-Developer_Program-313131?style=for-the-badge\&logo=epic-games\&logoColor=white)](https://dev.epicgames.com/)
<h3>Professional Profiles</h3>
  <p>
    <a href="https://www.linkedin.com/in/matt-a-porter-103535224/">
      <img src="https://img.shields.io/badge/LinkedIn-Matt--Porter-blue?style=flat-square&logo=linkedin" alt="Personal LinkedIn">
    </a>
    <a href="https://www.linkedin.com/company/95058568/">
      <img src="https://img.shields.io/badge/LinkedIn-Qompass--AI-blue?style=flat-square&logo=linkedin" alt="Startup LinkedIn">
    </a>
  </p>

<h3>Social Media</h3>
  <p>
    <a href="https://twitter.com/PhaedrusFlow">
      <img src="https://img.shields.io/badge/Twitter-@PhaedrusFlow-blue?style=flat-square&logo=twitter" alt="X/Twitter">
    </a>
    <a href="https://www.instagram.com/phaedrusflow">
      <img src="https://img.shields.io/badge/Instagram-phaedrusflow-purple?style=flat-square&logo=instagram" alt="Instagram">
    </a>
    <a href="https://www.youtube.com/@qompassai">
      <img src="https://img.shields.io/badge/YouTube-QompassAI-red?style=flat-square&logo=youtube" alt="Qompass AI YouTube">
    </a>
  </p>

</blockquote>
</details>

<details>
<summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #ff6b6b; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;"><strong>🔥 How Do I Support</strong></summary>
<blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #fff5f5; border-left: 6px solid #ff6b6b; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">

<div align="center">

<table>
<tr>
<th align="center">🏛️ Qompass AI Pre-Seed Funding 2023-2025</th>
<th align="center">🏆 Amount</th>
<th align="center">📅 Date</th>
</tr>
<tr>
<td><a href="https://github.com/qompassai/r4r" title="RJOS/Zimmer Biomet Research Grant Repository">RJOS/Zimmer Biomet Research Grant</a></td>
<td align="center">$30,000</td>
<td align="center">March 2024</td>
</tr>
<tr>
<td><a href="https://github.com/qompassai/PathFinders" title="GitHub Repository">Pathfinders Intern Program</a><br>
<small><a href="https://www.linkedin.com/posts/evergreenbio_bioscience-internships-workforcedevelopment-activity-7253166461416812544-uWUM/" target="_blank">View on LinkedIn</a></small></td>
<td align="center">$2,000</td>
<td align="center">October 2024</td>
</tr>
</table>

<br>
<h4>🤝 How To Support Our Mission</h4>

[![GitHub Sponsors](https://img.shields.io/badge/GitHub-Sponsor-EA4AAA?style=for-the-badge\&logo=github-sponsors\&logoColor=white)](https://github.com/sponsors/phaedrusflow)
[![Patreon](https://img.shields.io/badge/Patreon-Support-F96854?style=for-the-badge\&logo=patreon\&logoColor=white)](https://patreon.com/qompassai)
[![Liberapay](https://img.shields.io/badge/Liberapay-Donate-F6C915?style=for-the-badge\&logo=liberapay\&logoColor=black)](https://liberapay.com/qompassai)
[![Open Collective](https://img.shields.io/badge/Open%20Collective-Support-7FADF2?style=for-the-badge\&logo=opencollective\&logoColor=white)](https://opencollective.com/qompassai)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-FFDD00?style=for-the-badge\&logo=buy-me-a-coffee\&logoColor=black)](https://www.buymeacoffee.com/phaedrusflow)

<details markdown="1">
<summary><strong>🔐 Cryptocurrency Donations</strong></summary>

**Monero (XMR):**

<div align="center">
  <img src="https://raw.githubusercontent.com/qompassai/svg/main/assets/monero-qr.svg" alt="Monero QR Code" width="180">
</div>

<div style="margin: 10px 0;">
    <code>42HGspSFJQ4MjM5ZusAiKZj9JZWhfNgVraKb1eGCsHoC6QJqpo2ERCBZDhhKfByVjECernQ6KeZwFcnq8hVwTTnD8v4PzyH</code>
  </div>

<button onclick="navigator.clipboard.writeText('42HGspSFJQ4MjM5ZusAiKZj9JZWhfNgVraKb1eGCsHoC6QJqpo2ERCBZDhhKfByVjECernQ6KeZwFcnq8hVwTTnD8v4PzyH')" style="padding: 6px 12px; background: #FF6600; color: white; border: none; border-radius: 4px; cursor: pointer;">
    📋 Copy Address
  </button>
<p><i>Funding helps us continue our research at the intersection of AI, healthcare, and education</i></p>

</blockquote>
</details>
</details>

<details id="FAQ">
  <summary><strong>Frequently Asked Questions</strong></summary>

### Q: How do you mitigate against bias?

**TLDR - we do math to make AI ethically useful**

### A: We delineate between mathematical bias (MB) - a fundamental parameter in neural network equations - and algorithmic/social bias (ASB). While MB is optimized during model training through backpropagation, ASB requires careful consideration of data sources, model architecture, and deployment strategies. We implement attention mechanisms for improved input processing and use legal open-source data and secure web-search APIs to help mitigate ASB.

[AAMC AI Guidelines | One way to align AI against ASB](https://www.aamc.org/about-us/mission-areas/medical-education/principles-ai-use)

### AI Math at a glance

## Forward Propagation Algorithm

$$
y = w_1x_1 + w_2x_2 + ... + w_nx_n + b
$$

Where:

- $y$ represents the model output
- $(x_1, x_2, ..., x_n)$ are input features
- $(w_1, w_2, ..., w_n)$ are feature weights
- $b$ is the bias term

### Neural Network Activation

For neural networks, the bias term is incorporated before activation:

$$
z = \sum_{i=1}^{n} w_ix_i + b
$$
$$
a = \sigma(z)
$$

Where:

- $z$ is the weighted sum plus bias
- $a$ is the activation output
- $\sigma$ is the activation function

### Attention Mechanism- aka what makes the Transformer (The "T" in ChatGPT) powerful

- [Attention High level overview video](https://www.youtube.com/watch?v=fjJOgb-E41w)

- [Attention Is All You Need Arxiv Paper](https://arxiv.org/abs/1706.03762)

The Attention mechanism equation is:

$$
\text{Attention}(Q, K, V) = \text{softmax}\\left( \\frac{QK^T}{\\sqrt{d_k}} \\right) V
$$

Where:

- $Q$ represents the Query matrix
- $K$ represents the Key matrix
- $V$ represents the Value matrix
- $d_k$ is the dimension of the key vectors
- $\text{softmax}(\cdot)$ normalizes scores to sum to 1

### Q: Do I have to buy a Linux computer to use this? I don't have time for that!

### A: No. You can run Linux and/or the tools we share alongside your existing operating system:

- Windows users can use Windows Subsystem for Linux [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
- Mac users can use [Homebrew](https://brew.sh/)
- The code-base instructions were developed with both beginners and advanced users in mind.

### Q: Do you have to get a masters in AI?

### A: Not if you don't want to. To get competent enough to get past ChatGPT dependence at least, you just need a computer and a beginning's mindset. Huggingface is a good place to start.

- [Huggingface](https://docs.google.com/presentation/d/1IkzESdOwdmwvPxIELYJi8--K3EZ98_cL6c5ZcLKSyVg/edit#slide=id.p)

### Q: What makes a "small" AI model?

### A: AI models ~=10 billion(10B) parameters and below. For comparison, OpenAI's GPT4o contains approximately 200B parameters.

</details>

## License

This project is licensed under the [Apache License, Version 2.0](./LICENSE).

Copyright 2025 Qompass AI.

