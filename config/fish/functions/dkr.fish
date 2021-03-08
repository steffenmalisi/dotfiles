function dkr --description 'Prints verbose certificate information'
    if test $argv[1] = 'stopall'
        docker stop (docker ps -q)
    end
end