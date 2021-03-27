function manpdf -a manpage
  man -t $manpage | open -f -a Preview.app
end