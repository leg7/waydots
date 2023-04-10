function p --wraps='ls -hAsv1 --color auto --group-directories-first' --description 'alias l ls -hAsv1 --color auto --group-directories-first'
  ls -hAsv1 --color=auto --group-directories-first $argv

end
