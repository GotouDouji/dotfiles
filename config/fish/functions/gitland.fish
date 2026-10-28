function gitland --description "Squash merge the active savepoints branch back into baseline"
    set -l CURRENT_BRANCH (git branch --show-current)

    if not string match -r -- "-savepoints\$" "$CURRENT_BRANCH"
        echo "❌ Error: You are on '$CURRENT_BRANCH'."
        echo "This command must be run while standing on an active *-savepoints branch."
        return 1
    end

    set -l TARGET_BRANCH ("main")

    echo "🏁 Ready to land and squash history."
    echo "   Source: $CURRENT_BRANCH"
    echo "   Target: $TARGET_BRANCH"
    echo ""

    read -P "Proceed with squash merge? [y/N]: " CONFIRM
    if not string match -ri -- "^y" "$CONFIRM"
        echo "Aborted."
        return 0
    end

    echo "🔄 Switching to $TARGET_BRANCH..."
    git checkout $TARGET_BRANCH; or return 1

    echo "🗜️  Squashing 'SAVEPOINT REACHED' history..."
    git merge --squash $CURRENT_BRANCH

    if test $status -ne 0
        echo "❌ Merge conflict or error encountered! Changes left staged."
        return 1
    end

    echo ""
    echo "📝 Enter your final consolidated commit message:"
    read -P "> " COMMIT_MSG

    if test -z "$COMMIT_MSG"
        set COMMIT_MSG "feat: completed implementation from $CURRENT_BRANCH"
    end

    git commit -m "$COMMIT_MSG"

    echo ""
    read -P "🗑️  Delete temporary branch '$CURRENT_BRANCH'? [y/N]: " DELETE_CONFIRM
    if string match -ri -- "^y" "$DELETE_CONFIRM"
        git branch -D $CURRENT_BRANCH
        echo "✅ Branch deleted."
    end

    echo "🎉 Done! Your TDD cycle history is perfectly clean on $TARGET_BRANCH."
end
