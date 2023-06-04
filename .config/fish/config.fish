if status is-login
	eval (dircolors -c "$XDG_CONFIG_HOME"/dircolors/dracula | string replace 'setenv' 'set -x')
	# set -x GCC_COLORS 'error 01;31:warning 01;35:note 01;36:caret 01;32:locus 01:quote 01'
	# set -x FZF_DEFAULT_OPTS ' --color fg:#f8f8f2,bg:#282a36,hl:#bd93f9
	# --color fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
	# --color info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
	# --color marker:#ff79c6,spinner:#ffb86c,header:#6272a4
	# --layout reverse
	# --height 20%'

	if test -z "$DISPLAY" && test (tty) = /dev/tty1
      #Hyprland-wrapper
	end
end

if status is-interactive
	if test 0 -eq (shuf -i 0-1 -n1)
		set fish_greeting "$(cowsay "Hello King!")"\n
	else
		set fish_greeting "$(fortune -e | cowsay)"\n
	end

	fish_vi_key_bindings
	for mode in default normal insert visual
		bind -M $mode \cf "printf '\n'; file-manager; commandline -f repaint"

		bind -M $mode \cs "printf '\n'; fuzzy-cd; commandline -f repaint"
		bind -M $mode \ch "printf '\n'; fuzzy-history; commandline -f repaint"
		bind -M $mode \co "printf '\n'; fuzzy-open; commandline -f repaint"
		bind -M $mode \cp "printf '\n'; fuzzy-path; commandline -f repaint"
		bind -M $mode \ce "accept-autosuggestion"
	end
end
