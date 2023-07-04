function dkr --description 'Convenient docker functions'
    if test $argv[1] = 'stopall'
        docker stop (docker ps -q)
    end
end