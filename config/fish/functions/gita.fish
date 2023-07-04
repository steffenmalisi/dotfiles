function gita --description 'Convenient git functions'
    if test $argv[1] = 'status'
        # see also git log --branches --not --remotes --no-walk --decorate --oneline
        git fetch --prune --all
        set branches (git for-each-ref --format="%(refname:short) %(upstream) %(upstream:track)" refs/heads)

        echo "Branches ahead of upstream"
        echo "--------------------------"
        printf '%s\n' $branches | grep ahead
        echo

        echo "Branches behind upstream"
        echo "------------------------"
        printf '%s\n' $branches | grep behind
        echo

        echo "Branches gone from upstream"
        echo "---------------------------"
        printf '%s\n' $branches | grep gone
        echo

        echo "Branches with no upstream"
        echo "-------------------------"
        printf '%s\n' $branches | awk '{if (!$2) print $1;}'
        echo
    else if test $argv[1] = 'pull'
        set branches_behind (git for-each-ref --format="%(refname:short) %(upstream) %(upstream:track)" refs/heads | grep behind | awk '{print $1}')
        for branch in $branches_behind
          git checkout $branch
          git pull
        end
    else if test $argv[1] = 'prune'
        set branches_gone (git for-each-ref --format="%(refname:short) %(upstream) %(upstream:track)" refs/heads | grep gone | awk '{print $1}')
        for branch in $branches_gone
          git branch -D $branch
        end
    else if test $argv[1] = 'prune-local'
        set branches_local (git for-each-ref --format="%(refname:short) %(upstream) %(upstream:track)" refs/heads | awk '{if (!$2) print $1;}')
        for branch in $branches_local
          git branch -D $branch
        end
    else if test $argv[1] = 'co-remote'
        set branches_remote (git branch -r --format="%(refname:lstrip=3)")
        for branch in $branches_remote
          git checkout $branch
        end
    end
end