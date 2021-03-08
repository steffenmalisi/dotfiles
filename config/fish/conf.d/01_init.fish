set -gx DOTFILES_DIR ~/.dotfiles
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx XDG_CONFIG_HOME ~/.config

set PATH $DOTFILES_DIR/bin $PATH
set PATH /usr/local/opt/mysql-client/bin $PATH

for dir in $DOTFILES_DIR/bin/extra/*
  if test -d $dir
    set PATH $dir $PATH
  end
end