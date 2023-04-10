function hst
	set element (tac ~/.local/share/fish/fish_history | grep cmd | cut -c '8-' | fzf | tr -d '\n\r')
	if test -n $element
		echo $element | wl-copy
	end
end
