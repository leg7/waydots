function fuzzy-open
	if test (count $argv) -gt 0
		open $argv
	else
		set file (find -type d -name 'cache' -prune -o -type f | fzf)
		if test -n "$file"
			open $file
		end
	end
end
