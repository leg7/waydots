function dlv
	if test (count $argv) -gt 0
		yt-dlp --embed-subs --embed-thumbnail --embed-metadata --sponsorblock-remove all $argv
	else
		yt-dlp --embed-subs --embed-thumbnail --embed-metadata --sponsorblock-remove all (wl-paste)
	end
end
