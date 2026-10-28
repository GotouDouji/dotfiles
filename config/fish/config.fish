source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

starship init fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/evander/.ghcup/bin $PATH # ghcup-env
# pnpm
set -gx PNPM_HOME "/home/evander/.local/share/pnpm"

# binstall 
set -gx BINSTALL_DISABLE_TELEMETRY true

if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
#
bind \el 'ezafisher install plttn/fish-eza'

function y
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

fish_vi_key_bindings




#########################
####  ABBREVIATIONS  ####
#########################
abbr -a r 'yay -Rs'
abbr -a i 'yay -S'
abbr -a yazi y
abbr -a home ~
abbr -a steamg steam-games.sh
abbr -a hlconf 'nvim .config/hypr/hyprland.conf'
abbr -a fishconf 'nvim .config/fish/config.fish'
abbr -a bindconf 'nvim .config/hypr/modules/binds.conf'
abbr -a zz fzf
abbr -a f fish

#integrate zoxide into fish
zoxide init --cmd cd fish | source
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
