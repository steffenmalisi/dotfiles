SHELL = /bin/bash
SHELLS=/private/etc/shells
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PATH := $(DOTFILES_DIR)/bin:$(PATH)
NVM_DIR := $(HOME)/.nvm
SDKMAN_DIR := $(HOME)/.sdkman
export XDG_CONFIG_HOME = $(HOME)/.config
export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

.PHONY: test

all: sudo core packages link

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

core: brew fish git npm ruby sdkman

# -------------- CORE Binaries ------------------
brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

fish: FISH=/usr/local/bin/fish
fish: brew
ifdef GITHUB_ACTION
	if ! grep -q $(FISH) $(SHELLS); then \
		brew install fish pcre && \
		curl -L https://get.oh-my.fish > install.fish && fish install.fish --noninteractive --yes && rm install.fish && \
		sudo append $(FISH) $(SHELLS) && \
		sudo chsh -s $(FISH); \
	fi
else
	if ! grep -q $(FISH) $(SHELLS); then \
		brew install fish pcre && \
		curl -L https://get.oh-my.fish > install.fish && fish install.fish --noninteractive --yes && rm install.fish && \
		sudo append $(FISH) $(SHELLS) && \
		chsh -s $(FISH); \
	fi
endif

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
packages: brew-packages cask-apps sdk-packages

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	#defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
	for EXT in $$(cat install/Codefile); do code --install-extension $$EXT; done
	#xattr -d -r com.apple.quarantine ~/Library/QuickLook

node-packages: npm
	. $(NVM_DIR)/nvm.sh; npm install -g $(shell cat install/npmfile)

sdk-packages: sdkman
	. $(SDKMAN_DIR)/bin/sdkman-init.sh; while read line; do sdk install $$line; done < install/Sdkfile

# -------------- Stow Linking ------------------
stow: brew
	is-executable stow || brew install stow

link: stow
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	rm -rf $(XDG_CONFIG_HOME)/fish $(XDG_CONFIG_HOME)/omf && stow -t $(XDG_CONFIG_HOME) config

unlink: stow
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done


# -------------- Other Shells ------------------
bash: BASH=/usr/local/bin/bash
bash: brew
ifdef GITHUB_ACTION
	if ! grep -q $(BASH) $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append $(BASH) $(SHELLS) && \
		sudo chsh -s $(BASH); \
	fi
else
	if ! grep -q $(BASH) $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append $(BASH) $(SHELLS) && \
		chsh -s $(BASH); \
	fi
endif

# -------------- Other ------------------

test:
	. $(NVM_DIR)/nvm.sh; bats test
