function gp
	set path $PWD(find -type d -name 'cache' -prune -o -type d -o -type f | fzf | cut -c '2-' | tr -d '\n\r')
	echo $path | wl-copy && echo copied path $path
end
