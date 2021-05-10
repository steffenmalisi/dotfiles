# Dotfiles

These are my dotfiles

# Installation

### 1. Install system software updates and xcode-select (Only needed on a fresh installation of macOS)
```bash
sudo softwareupdate -i -a -R --fetch-full-installer
xcode-select --install
sudo xcodebuild -license accept
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
### 4. Post installation

#### 4.1 Scripts to run manually
- `dotfiles macos`
- `dotfiles dock`


#### 4.2 Restore Mackup
First configure your Mackup backup file store (in my case it is Nextcloud).
Then run `mackup restore`

#### 4.3 Setup Browser Plugins

#### 4.4 Setup KeepassXC
- [Enable SSHAgent](https://keepassxc.org/docs/#faq-ssh-agent-how)
- [Enable Browser Integration](https://keepassxc.org/docs/KeePassXC_GettingStarted.html#_setup_browser_integration)

# Credits

Heavily inspired by / based on:

* https://github.com/webpro/dotfiles
* https://github.com/mathiasbynens/dotfiles