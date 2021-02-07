function cleanup
  switch (echo $argv[1])
  case 'ds'
    find . -type f -name '*.DS_Store' -ls -delete
  case 'ad'
    find . -type d -name '.AppleD*' -ls -exec /bin/rm -r {} \;
  case 'launch'
    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
  case 'trash'
    sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl
  case '*'
    echo 'Not supported. Please provide a valid argument of what to cleanup.'
  end
end