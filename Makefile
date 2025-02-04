SHELL=/bin/bash
FISH=/usr/local/bin/fish
SHELLS=/private/etc/shells
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PATH := $(DOTFILES_DIR)/bin:$(PATH)
NVM_DIR := $(HOME)/.nvm
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

.PHONY: test

all: core packages link

# -------------- CORE Binaries ------------------
core: brew fish omf git npm

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

fish: brew
	brew install fish pcre

omf: fish
	curl -L https://get.oh-my.fish > install.fish && fish install.fish --noninteractive --yes && rm install.fish

git: brew
	brew install git git-extras

npm:
	if ! [ -d $(NVM_DIR)/.git ]; then git clone https://github.com/nvm-sh/nvm $(NVM_DIR); fi
	. $(NVM_DIR)/nvm.sh; nvm install --lts

# -------------- Core Packages ------------------
packages: brew-packages node-packages pipx-packages omf-packages colima

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile

node-packages: npm
	. $(NVM_DIR)/nvm.sh; npm install -g $(shell cat install/Npmfile)

pipx-packages: brew
	while read line; do pipx install $$line; done < install/Pipxfile

omf-packages: omf
omf-packages: link
	$(FISH) -c 'omf install'

colima: brew
	brew install colima docker docker-compose docker-credential-helper docker-buildx

# -------------- Apps ------------------
apps: vs-code cask-apps mas-apps

vs-code:
	brew install --cask visual-studio-code
	for EXT in $$(cat install/Codefile); do code --install-extension $$EXT; done

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
	xattr -d -r com.apple.quarantine ~/Library/QuickLook

mas-apps: brew
	if mas account > /dev/null; then brew bundle --file=$(DOTFILES_DIR)/install/Masfile; fi

# -------------- Stow Linking ------------------
stow: brew
	is-executable stow || brew install stow

link: stow
	mkdir -p $(XDG_CONFIG_HOME)
	rm -rf $(XDG_CONFIG_HOME)/fish $(XDG_CONFIG_HOME)/omf && stow -t $(XDG_CONFIG_HOME) config
	ln -s $(HOME)/.config/mackup/.mackup.cfg $(HOME)

unlink: stow
	stow --delete -t $(XDG_CONFIG_HOME) config

# -------------- Other ------------------

test:
	. $(NVM_DIR)/nvm.sh; bats test
