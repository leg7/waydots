function upload
	if test (count $argv) -eq 0
		return
	end

	for i in $argv
		if test -f $i
			curl -F "file=@$i" https://0x0.st
		end
	end
end
