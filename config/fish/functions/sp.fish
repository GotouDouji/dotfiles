# savepoint-squash — wraps savepoint and collapses its autosaves on exit

function sp "Wraps savepoint and collapses its autosaves on exit"
	if not type -q savepoint
		echo "error: 'savepoint' not found in PATH"
		return 1
	end
	set ORIGINAL_HEAD (git rev-parse HEAD)
	
	# Forward all args to savepoint; 'or true' so Ctrl+C doesn't abort the script
	savepoint $argv; or true
	
	# Count how many "SAVEPOINT REACHED!" commits were created
	set COUNT (git rev-list --count --grep="SAVEPOINT REACHED!" "$ORIGINAL_HEAD..HEAD")
	if test "$COUNT" -eq 0
		echo "No savepoint commits to squash."
		return 0
	end
	echo "Squashing $COUNT savepoint commit(s)..."
	
	# Find the first autosave commit and its parent
	set FIRST_SAVEPOINT (git log --reverse --format="%H" --grep="SAVEPOINT REACHED!" "$ORIGINAL_HEAD..HEAD" | head -1)
	set SQUASH_BASE (git rev-parse "$FIRST_SAVEPOINT^")

	# Soft reset: all changes from the autosave commits become staged
	git reset --soft "$SQUASH_BASE"
	
	# Commit as one
	git commit -m "wip: savepoint squash ($COUNT autosaves)"
	echo "Done."
end
