function monero --wraps='cd $XDG_DATA_HOME/monero && monero-wallet-cli && killall monerod && cd -' --description 'alias monero cd $XDG_DATA_HOME/monero && monero-wallet-cli && killall monerod && cd -'
  cd $XDG_DATA_HOME/monero && monero-wallet-cli $argv && killall monerod && cd -

end
