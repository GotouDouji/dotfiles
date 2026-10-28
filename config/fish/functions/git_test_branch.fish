function git_test_branch
   # Define options using fish's built-in argparse
    argparse 'b/base=' -- $argv
    or return 1

    # Set default base branch to main if not provided via -b/--base
    set -l base_branch "main"
    if set -q _flag_base
        set base_branch $_flag_base
    end

    # Check for remaining required arguments
    if test (count $argv) -lt 2
        echo "Usage: git_merge_branches [-b <base-branch>] <test-branch> <branch1> [branch2 ...]"
        return 1
    end

    set -l test_branch $argv
    set -l branches $argv[2..-1]

    # Confirmation Prompt
    echo "⚠️  WARNING: This will completely RESET '$test_branch' to match '$base_branch'."
    read -l -P "Are you sure you want to proceed? [y/N]: " confirm
    switch $confirm
        case y Y yes Yes YES
            # Proceed with the script
        case '*'
            echo "Operation aborted."
            return 0
    end

    # Checkout base and get latest updates
    git checkout $base_branch; or return 1
    git pull; or return 1

    # Force reset or recreate the test branch safely using switch -C
    echo "Resetting $test_branch to match $base_branch..."
    git switch -C $test_branch; 

    # Merge specified branches
    for branch in $branches
        echo "Merging $branch into $test_branch..."
        git merge --no-edit $branch
        if test $status -ne 0
            echo "Conflict or error while merging $branch. Aborting merge for this branch."
            git merge --abort
            return 1
        end
    end
end
