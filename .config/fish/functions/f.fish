function f --wraps='nemo ./' --description 'alias f nemo ./'
	if test (count $argv) -eq 0
		nemo ./
	else
		nemo $argv
	end
end
