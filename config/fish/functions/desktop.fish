function desktop
    set show true
    if test $argv[1] = 'show'
        set show true
    else if test $argv[1] = 'hide'
        set show false
    end
    defaults write com.apple.finder CreateDesktop -bool $show && killall Finder
end