function file-manager
	if test (count $argv) -eq 0
		nemo ./
	else
		nemo $argv
	end
end
