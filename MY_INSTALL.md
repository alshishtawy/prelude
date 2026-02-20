# Emacs 30.1 + Prelude Setup Guide (WSL/Ubuntu)

This guide covers how to compile Emacs 30.1 from source with recommended
features and set up the Prelude Emacs configuration optimized for web
development, Rust, and C++.

---

## 1. Install Build Dependencies

```bash
sudo apt update
sudo apt install -y \
  build-essential libgtk-3-dev libgnutls28-dev libtiff-dev \
  libgif-dev libjpeg-dev libpng-dev libxpm-dev libncurses-dev \
  libgccjit-$(gcc -dumpversion | cut -d. -f1)-dev libjansson-dev libharfbuzz-dev libtree-sitter-dev \
  libcairo2-dev libxml2-dev libmagickwand-dev libxft-dev \
  texinfo libacl1-dev libgpm-dev git curl
# for vterm
sudo apt install cmake libtool-bin libvterm-dev
```

---

## 2. Download and Build Emacs 30.1

```bash
cd $HOME
wget https://ftp.gnu.org/gnu/emacs/emacs-30.1.tar.xz
tar -xf emacs-30.1.tar.xz
cd emacs-30.1

./configure --prefix=$HOME/emacs \
  --with-x --with-x-toolkit=gtk3 \
  --with-modules \
  --with-cairo --with-harfbuzz \
  --with-tree-sitter \
  --with-native-compilation=aot \
  --with-imagemagick

make -j$(nproc)
make install
```

---

## 3. Add Emacs to Your PATH

Append to your `.bashrc`, `.zshrc`, or equivalent shell config:

```bash
export PATH="$HOME/emacs/bin:$PATH"
```

Then reload:

```bash
source ~/.bashrc  # or ~/.zshrc
```

---

## 4. Install Prelude

```bash
git clone git@github.com:alshishtawy/prelude.git ~/prelude
ln -s ~/prelude ~/.emacs.d
```

Start Emacs and let it install its packages.

---

## 5. Install Prelude Runtime Tools

Install tools used by Prelude for spell-checking, linting, and navigation:

```bash
sudo apt install -y \
  aspell aspell-en ripgrep shellcheck \
  tidy jq clang clangd cppcheck \
  python3 python3-venv

sudo apt install -y pipx
pipx ensurepath
source ~/.bashrc
pipx install flake8
pipx install black
pipx install isort
pipx install virtualenvwrapper
```

Install Rust:

```bash
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
rustup component add rust-analyzer
```

Install Node.js + JS tooling:

```bash
# Install fnm (Fast Node Manager) via cargo
cargo install fnm

# After adding fnm to ~/.bashrc (see below) and reloading your shell:
fnm install --lts
fnm default lts-latest

# Enable pnpm via Corepack (bundled with Node.js since v16.9)
corepack enable
corepack prepare pnpm@latest --activate

# Install JS tooling globally
pnpm add -g eslint prettier
```

Add virtualenvwrapper and vterm shell integration to `~/.bashrc`:

```bash
# fnm (Fast Node Manager)
eval "$(fnm env --use-on-cd)"

# virtualenvwrapper (installed via pipx)
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=$HOME/.local/pipx/venvs/virtualenvwrapper/bin/python
source $HOME/.local/bin/virtualenvwrapper.sh

# vterm shell integration (directory tracking, clear, etc.)
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    source ~/.emacs.d/elpa/vterm-*/etc/emacs-vterm-bash.sh
fi
```

Install fonts for vterm Unicode glyph support (symbols, icons, box-drawing):

```bash
sudo apt install -y fonts-symbola
```

Optional:

```bash
sudo apt install -y editorconfig
```

---

## 6. Optional: Tree-sitter Language Grammar Setup

Emacs 30.1 includes Tree-sitter support. To enable syntax trees for additional
languages:

```elisp
;; Example for Rust
(add-to-list 'treesit-language-source-alist
             '(rust "https://github.com/tree-sitter/tree-sitter-rust"))
```

You can manage grammars manually or use the `treesit-auto` package.

---

## 7. Notes

- The `--with-json` flag is no longer needed (JSON support is built-in in 30.1).
- `--with-x --with-x-toolkit=gtk3` requires a working X server. On WSL2 with Windows 11, WSLg provides this automatically. On Windows 10, install VcXsrv and set `DISPLAY=:0` in your `.bashrc`.
- Only use `sudo make install` if you're installing to system paths like
  `/usr/local`.
- The `--with-mailutils` flag is only needed if you want legacy
  `rmail`/`movemail` support — not required for development.
- Native compilation is enabled by default, but `--with-native-compilation=aot`
  forces ahead-of-time bytecode compilation.

---

## 8. Result

This setup provides:

- A GUI-capable, fast Emacs with native compilation and Tree-sitter
- Full Prelude configuration
- Ready-to-go environment for:

  - Web dev (HTML, CSS, JS, React, Django)
  - C++ (clangd, LSP, linting)
  - Rust (rust-analyzer, cargo)
  - Python (venv, flake8, black)
