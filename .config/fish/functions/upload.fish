function upload
	if test (count $argv) -eq 0
		return
	end

	for i in $argv
		if test -f $i
			set url (curl -sF "file=@$i" https://0x0.st)
			wl-copy $url
			printf "\n$i: $url copied to the clipboard\n"
		end
	end
end
