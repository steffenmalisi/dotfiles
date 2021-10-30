SHELL=/bin/bash
FISH=/usr/local/bin/fish
SHELLS=/private/etc/shells
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PATH := $(DOTFILES_DIR)/bin:$(PATH)
NVM_DIR := $(HOME)/.nvm
SDKMAN_DIR := $(HOME)/.sdkman
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

.PHONY: test

all: sudo core packages link macos

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

# -------------- CORE Binaries ------------------
core: brew fish omf git npm ruby sdkman

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

fish: brew
ifdef GITHUB_ACTION
	if ! grep -q $(FISH) $(SHELLS); then \
		brew install fish pcre && \
		sudo append $(FISH) $(SHELLS) && \
		sudo chsh -s $(FISH); \
	fi
else
	if ! grep -q $(FISH) $(SHELLS); then \
		brew install fish pcre && \
		sudo append $(FISH) $(SHELLS) && \
		chsh -s $(FISH); \
	fi
endif

omf: fish
	curl -L https://get.oh-my.fish > install.fish && fish install.fish --noninteractive --yes && rm install.fish

git: brew
	brew install git git-extras

npm:
	if ! [ -d $(NVM_DIR)/.git ]; then git clone https://github.com/nvm-sh/nvm $(NVM_DIR); fi
	. $(NVM_DIR)/nvm.sh; nvm install --lts

rbenv: brew
	is-executable rbenv || brew install rbenv

ruby: LATEST_RUBY=$(shell rbenv install -l | grep -v - | tail -1)
ruby: rbenv
	rbenv install -s $(LATEST_RUBY)
	rbenv global $(LATEST_RUBY)

sdkman:
	if ! [ -d $(SDKMAN_DIR) ]; then curl -s "https://get.sdkman.io" | bash; fi

# -------------- Packages ------------------
packages: brew-packages cask-apps mas-apps node-packages sdk-packages pipx-packages omf-packages

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
	for EXT in $$(cat install/Codefile); do code --install-extension $$EXT; done
	xattr -d -r com.apple.quarantine ~/Library/QuickLook

mas-apps: brew
	if mas account > /dev/null; then brew bundle --file=$(DOTFILES_DIR)/install/Masfile; fi

node-packages: npm
	. $(NVM_DIR)/nvm.sh; npm install -g $(shell cat install/Npmfile)

sdk-packages: sdkman
	. $(SDKMAN_DIR)/bin/sdkman-init.sh; while read line; do sdk install $$line; done < install/Sdkfile

pipx-packages: brew
	while read line; do pipx install $$line; done < install/Pipxfile

omf-packages: omf
omf-packages: link
	$(FISH) -c 'omf install'

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

macos:
	dotfiles macos

test:
	. $(NVM_DIR)/nvm.sh; bats test
