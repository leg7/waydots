function wa
	if test (count $argv) -gt 0
		mpv "$argv"
	else
		mpv "$(wl-paste)"
	end
end
