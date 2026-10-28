function cf --description 'Fuzzy-find and cd into a directory using fd'
    # Search for directories, including hidden ones, but ignoring .git
    set -l dir (fd --type d --hidden --exclude .git . $HOME $argv | fzf +m --preview 'fd --max-depth 1 . {}')
    
    # If a directory was selected, cd into it
    if test -n "$dir"
        cd "$dir"
    end
end
