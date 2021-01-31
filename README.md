# Dotfiles

These are my dotfiles

# Installation

### 1. Install system software updates and xcode-select (Only needed on a fresh installation of macOS)
```bash
sudo softwareupdate -i -a
xcode-select --install
```

### 2. Clone the repo
```bash
git clone https://github.com/steffenmalisi/dotfiles.git ~/.dotfiles
```

### 3. Start the installation
```bash
cd ~/.dotfiles
make
```
   

# Credits

Heavily inspired by / based on:

* https://github.com/webpro/dotfiles
* https://github.com/mathiasbynens/dotfiles