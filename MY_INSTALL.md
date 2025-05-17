# Emacs 30.1 + Prelude Setup Guide (WSL/Ubuntu)

This guide covers how to compile Emacs 30.1 from source with recommended features and set up the Prelude Emacs configuration optimized for web development, Rust, and C++.

---

## 1. Install Build Dependencies

```bash
sudo apt update
sudo apt install -y \
  build-essential libgtk-3-dev libgnutls28-dev libtiff-dev \
  libgif-dev libjpeg-dev libpng-dev libxpm-dev libncurses-dev \
  libgccjit-12-dev libjansson-dev libharfbuzz-dev libtree-sitter-dev \
  libcairo2-dev libxml2-dev libmagickwand-dev libxft-dev \
  texinfo libacl1-dev libgpm-dev git curl
````

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
git clone --depth 1 https://github.com/bbatsov/prelude.git ~/.emacs.d
```

Start Emacs and let it install its packages.

---

## 5. Install Prelude Runtime Tools

Install tools used by Prelude for spell-checking, linting, and navigation:

```bash
sudo apt install -y \
  aspell aspell-en ripgrep shellcheck \
  tidy jq clang clangd cppcheck \
  python3 python3-pip python3-venv

pip3 install flake8 black isort
```

Install Rust:

```bash
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
rustup component add rust-analyzer
```

Install Node.js + JS tooling:

```bash
sudo apt install -y nodejs npm
sudo npm install -g eslint prettier
```

Optional:

```bash
sudo apt install -y editorconfig
```

---

## 6. Optional: Tree-sitter Language Grammar Setup

Emacs 30.1 includes Tree-sitter support. To enable syntax trees for additional languages:

```elisp
;; Example for Rust
(add-to-list 'treesit-language-source-alist
             '(rust "https://github.com/tree-sitter/tree-sitter-rust"))
```

You can manage grammars manually or use the `treesit-auto` package.

---

## 7. Notes

* The `--with-json` flag is no longer needed (JSON support is built-in in 30.1).
* Only use `sudo make install` if you're installing to system paths like `/usr/local`.
* The `--with-mailutils` flag is only needed if you want legacy `rmail`/`movemail` support — not required for development.
* Native compilation is enabled by default, but `--with-native-compilation=aot` forces ahead-of-time bytecode compilation.

---

## 8. Result

This setup provides:

* A GUI-capable, fast Emacs with native compilation and Tree-sitter
* Full Prelude configuration
* Ready-to-go environment for:

  * Web dev (HTML, CSS, JS, React, Django)
  * C++ (clangd, LSP, linting)
  * Rust (rust-analyzer, cargo)
  * Python (venv, flake8, black)
