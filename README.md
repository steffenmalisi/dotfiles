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
- https://chrome.google.com/webstore/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk?hl=en-US
- https://chrome.google.com/webstore/detail/i-dont-care-about-cookies/fihnjjcciajhdojfnbdddfaoknhalnja?hl=en-US
- https://chrome.google.com/webstore/detail/duckduckgo-privacy-essent/bkdgflcldnnnapblkhphbgpggdiikppg?hl=en-US
- https://chrome.google.com/webstore/detail/xbrowsersync/lcbjdhceifofjlpecfpeimnnphbcjgnc?hl=en-US

#### 4.4 Setup KeepassXC
- [Enable SSHAgent](https://keepassxc.org/docs/#faq-ssh-agent-how)
- [Enable Browser Integration](https://keepassxc.org/docs/KeePassXC_GettingStarted.html#_setup_browser_integration)


#### 4.6 Launch at Login
- Hammerspoon
- Itsycal
- Deepl
- Maccy

#### 4.8 Setup Menu Bar
- Clock
- Battery
- 
#### 4.7 Others
- Add Hammerspoon to Accessability privacy policy
- Add OneDrive Sync
- Create folder structure for dev
- Setup Chromium as default browser
- Setup Itsycal
- Audio Midi Setup
- Update Routines for packages (Cron??)


# Credits

Heavily inspired by / based on:

* https://github.com/webpro/dotfiles
* https://github.com/mathiasbynens/dotfiles