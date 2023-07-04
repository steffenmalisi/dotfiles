set -gx DOTFILES_DIR ~/.dotfiles
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx XDG_CONFIG_HOME ~/.config
set -gx GPG_TTY (tty)
set -gx GOPATH $HOME/go;
set -gx GOROOT $HOME/.go;
set -gx CHROME_EXECUTABLE /Applications/Brave\ Browser.app/Contents/MacOS/Brave\ Browser

set PATH $DOTFILES_DIR/bin $PATH
set PATH /usr/local/opt/mysql-client/bin $PATH
set PATH /usr/local/opt/openssl@1.1/bin $PATH
set PATH /usr/local/opt/curl/bin $PATH
set PATH $GOPATH/bin $PATH;
set PATH $PATH $HOME/.local/bin

for dir in $DOTFILES_DIR/bin/extra/*
  if test -d $dir
    set PATH $dir $PATH
  end
end