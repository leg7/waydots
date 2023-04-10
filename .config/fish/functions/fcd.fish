function fcd
	set dir (find -L "$PWD" -type d -name 'cache' -prune -o -type d | fzf)/ # Ignore . files
	test -n "$dir" && c "$dir"
end

