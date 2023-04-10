function li
	if test (count $argv) -gt 0
		/usr/bin/mpv --vid=no --force-window=no "$argv"
	else
		mpv "$(wl-paste)"
	end
end
