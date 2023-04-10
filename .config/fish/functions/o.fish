function o
	if test (count $argv) -gt 0
		open $argv
	else
		set file (find -type d -name 'cache' -prune -o -type f | fzf)
		open $file
	end
end
