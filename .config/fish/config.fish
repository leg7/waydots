if status is-login
	set -x EDITOR     vim
	set -x PAGER      less
	set -x BROWSER    firefox

	set -x PATH                  $HOME/.local/bin $PATH
	set -x XDG_CONFIG_HOME       $HOME/.config
	set -x XDG_DATA_HOME         $HOME/.local/share
	set -x XDG_CACHE_HOME        $HOME/.local/cache
	set -x XDG_STATE_HOME        $HOME/.local/state

	set -x GNUPGHOME             $XDG_DATA_HOME/gnupg
	set -x WGETRC                $XDG_CONFIG_HOME/wget/wgetrc
	set -x GOPATH                $XDG_DATA_HOME/go
	set -x GOMODCACHE            $XDG_CACHE_HOME/go/mod
	set -x RUSTUP_HOME           $XDG_DATA_HOME/rustup
	set -x CARGO_HOME            $XDG_DATA_HOME/cargo
	set -x STACK_ROOT            $XDG_DATA_HOME/stack
	set -x NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
	set -x NUGET_PACKAGES        $XDG_CACHE_HOME/NuGetPackages
	set -x NODE_REPL_HISTORY     $XDG_DATA_HOME/node_repl_history
	set -x VIMINIT               "set nocp | source $XDG_CONFIG_HOME/vim/vimrc"

	eval (dircolors -c "$XDG_CONFIG_HOME"/dircolors/dracula | string replace 'setenv' 'set -x')
	set -x GCC_COLORS 'error 01;31:warning 01;35:note 01;36:caret 01;32:locus 01:quote 01'
	set -x FZF_DEFAULT_OPTS ' --color fg:#f8f8f2,bg:#282a36,hl:#bd93f9
	--color fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
	--color info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
	--color marker:#ff79c6,spinner:#ffb86c,header:#6272a4
	--layout reverse
	--height 20%'

	# See ~/.config/hypr/hyprland.conf for auto-start of daemons for gui programs
	set -l autostart mpd "syncthing --logfile=$XDG_DATA_HOME/syncthing/logs/log > /dev/null"

	printf "\n"
	for command in $autostart
		set -l program (string replace -r ' .*$' '' $command)

		if not pidof -q $program
			eval $command' &'
		else
			echo $program is already running.
		end
	end

	doas wg-quick up switz
	printf "\n"

	if test -z "$DISPLAY" && test (tty) = /dev/tty1
		Hyprland-wrapper
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
