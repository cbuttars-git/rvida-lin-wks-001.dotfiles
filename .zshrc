
###############################################################################
#
#     Setup environment variables first
#
###############################################################################
export ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
export CONFIG="$HOME/.config"
export LOCAL="$HOME/.local"
export MY_BASH_SCRIPTS="$LOCAL/share/my-bash-scripts"
export STARSHIP_CONFIG="$CONFIG/starship/starship.toml"
export XDG_CONFIG_HOME="$CONFIG"
export DOTNET_ROOT="$HOME/.dotnet"
export NVM_DIR="$HOME/.nvm"
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1  # make prompt faster
export DISABLE_MAGIC_FUNCTIONS=true     # make pasting into terminal faster
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export EDITOR=nvim
export VISUAL=nvim
export HISTCONTROL=ignoreboth:erasedups
export PAGER="most"
export GPG_TTY=$(tty)
export PS1="[\u@\h \W]\$ "
export LIBVIRT_DEFAULT_URI="qemu:///system"
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#     FZF Specific Environment Variables
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
export FD_OPTIONS="--hidden --follow"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
# export FZF_DEFAULT_OPTS="--prompt '⯈ ' --marker=+ --color=dark --layout=reverse --color=fg:250,fg+:15,hl:203,hl+:203 --color=info:100,pointer:15,marker:220,spinner:11,header:-1,gutter:-1,prompt:15"
export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS || git ls-files --cached --others --exclude-standard"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
export FZF_COMPLETION_OPTS="-x"

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#     History Specific Environment Variables
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
export HISTSIZE=300000
export SAVEHIST=$HISTSIZE
export HISTFILE=~/.zsh_history
export HISTDUP=erase

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#     Paths are just environment variables but since they are built
#     I want to keep them sperated for visibility reasons.
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
export PATH="$PATH:/usr/lib/cache/bin/"
export PATH="$PATH:$HOME/Development/bash_scripts/"
export PATH="$PATH:$DOTNET_ROOT"
export PATH="$PATH:$DOTNET_ROOT/tools/"
export PATH="$PATH:$CONFIG/emacs/bin/"
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi


###############################################################################
#
#     If not running interactively the rest of this configuration is
#     worthless.
#
###############################################################################
[[ $- != *i* ]] && return

###############################################################################
#
#     Setup source files here
#
###############################################################################
# source "$HOME/.config/zshrc/catppuccin_mocha-zsh-syntax-highlighting.zsh"

###############################################################################
#
#     Setup fastfetch
#
#     Using fastfetch over pfetch or neofetch for console header consumption reduction.
#
###############################################################################
echo ""
if [[ $(tty) == *"pts"* ]]; then
      fastfetch
    # pfetch
else
    if [ -f /bin/qtile ]; then
        echo "Start Qtile X11 with command Qtile"
    fi
    if [ -f /bin/hyprctl ]; then
        echo "Start Hyprland with command Hyprland"
    fi
fi

###############################################################################
#
#     Setup zinit zsh package manager
#
###############################################################################
if [[ ! -d "$ZINIT_HOME" ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
        mkdir -p "$(dirname $ZINIT_HOME)" && chmod g-rwX "$ZINIT_HOME"
    command git clone https://github.com/zdharma/zinit "$ZINIT_HOME" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$ZINIT_HOME/zi.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

###############################################################################
#
#     Disabled the starship prompt as I do not find it to be as nice as the
#     Powerlevel10K prompt
#
#     Installing and starting the starship prompt
#
###############################################################################
# zinit ice from"gh-r" as"command" atload'eval "$(starship init zsh)"'
# zinit load starship/starship

###############################################################################
#
#     Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
#     Initialization code that may require console input (password prompts, [y/n]
#     confirmations, etc.) must go above this block; everything else may go below.
#
###############################################################################
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

zinit depth=1 lucid nocd for \
    romkatv/powerlevel10k

###############################################################################
#
#    Loading OhMyZsh Libraries (OMZL) and OhMyZsh Plugins (OMZP) 
#
#    !!!!!     IMPORTANT     !!!!!
#    Ohmyzsh plugins and libs are loaded first as some these sets some defaults
#    which are required later on. Otherwise something will look messed up.
#    Some settings help zsh-autosuggestions to clear after tab completion#
#
###############################################################################
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#     Setup tmux OMZP
#     It is installed and setup first to prevent jumps when tmux is
#     loaded after ".zshrc".
#
#     It will only be loaded on first start
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
zinit ice atinit"
        ZSH_TMUX_FIXTERM=true;
        ZSH_TMUX_AUTOSTART=false;
        ZSH_TMUX_AUTOCONNECT=true;"
zinit snippet OMZP::tmux

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#     !!!!!     IMPORTANT     !!!!!!
#     OMZL functions library is required by many of the other
#     libraries, so it must be called first.
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
zinit wait lucid for \
  OMZL::functions.zsh \
	OMZL::clipboard.zsh \
	OMZL::compfix.zsh \
	OMZL::completion.zsh \
	OMZL::correction.zsh \
    atload"
        alias ..='cd ..'
        alias ...='cd ../..'
        alias ....='cd ../../..'
        alias .....='cd ../../../..'
    " \
	OMZL::directories.zsh \
	OMZL::git.zsh \
	OMZL::grep.zsh \
	OMZL::history.zsh \
	OMZL::key-bindings.zsh \
	OMZL::spectrum.zsh \
	OMZL::termsupport.zsh

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#    OMZP plugins configuration
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
zinit wait lucid for \
        OMZP::azure \
        OMZP::command-not-found \
        OMZP::docker \
    atload"
        alias dcupb='docker-compose up --build'
    " \
        OMZP::docker-compose \
	    as"
                completion
            " \
        OMZP::dotnet \
        OMZP::encode64 \
        OMZP::fzf \
    atload"
        alias gcd='gco dev'
    " \
	OMZP::git \
	OMZP::gpg-agent \
        OMZP::podman \
        OMZP::sudo \
        OMZP::urltools

###############################################################################
#
#     Zinit Plugin configuration
#
#     !!!!! IMPORTANT     !!!!!
#     These plugins should be loaded after ohmyzsh plugins.
#
###############################################################################
zinit wait lucid for \
  light-mode \
    atinit"
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    " \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  light-mode \
    zsh-users/zsh-syntax-highlighting \
  light-mode \
    atinit"
      zstyle ':completion:*' completer _expand _complete _ignored _approximate
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
      zstyle ':completion:*' menu select=2 
      zstyle ':completion:*:descriptions' format '-- %d --'
      zstyle ':completion:*:processes' command 'ps -au$USER'
      zstyle ':completion:complete:*:options' sort false
      zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm,cmd -w -w'
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
      zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
    " \
    zsh-users/zsh-completions \
  light-mode \
    bindmap"
      ^R -> ^H
    " \
    atinit"
      zstyle :history-search-multi-word page-size 10
      zstyle :history-search-multi-word highlight-color fg=red,bold
      zstyle :plugin:history-search-multi-word reset-prompt-protect 1
    " \
    zdharma/history-search-multi-word \
    reset \
    atclone"local P=${${(M)OSTYPE:#*darwin*}:+g} \${P}sed -i \
      '/DIR/c\DIR 38;5;63;1' LS_COLORS; \
      \${P}dircolors -b LS_COLORS > c.zsh
    " \
    atpull"%atclone" \
    pick"c.zsh" \
    nocompile"!" \
    atload"zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'" \
    trapd00r/LS_COLORS \
  light-mode \
    Aloxaf/fzf-tab

###############################################################################
#
#    Load Completions
#
###############################################################################
autoload -U compinit && compinit
zinit cdreplay -q

###############################################################################
#
#    Start shell integration
#
###############################################################################
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

###############################################################################
#
#     Set zshrc options
#
###############################################################################
setopt ALWAYS_TO_END            # If a completion is performed with the cursor within a word, and a full completion is inserted, the cursor is moved to the end of the word.
setopt APPEND_HISTORY           # If this is set, zsh sessions will append their history list to the history file, rather than replace it.
setopt AUTO_MENU                # Automatically use menu completion after the second consecutive request for completion.
setopt COMPLETE_ALIASES         # Prevents aliases on the command line from being internally substituted before completion is attempted.
setopt COMPLETE_IN_WORD         # If unset, the cursor is set to the end of the word if completion is started. Otherwise it stays there and completion is done from both ends.
setopt EXTENDED_HISTORY         # Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file. 
setopt GLOB_DOTS                # Do not require a leading ‘.’ in a filename to be matched explicitly.
setopt HASH_LIST_ALL            # Whenever a command completion or spelling correction is attempted, make sure the entire command path is hashed first.
setopt HIST_EXPIRE_DUPS_FIRST   # If the internal history needs to be trimmed to add the current command line the oldest history event that has a duplicate is lost.
setopt HIST_IGNORE_ALL_DUPS     # If a new command line being added to the history list duplicates an older one, the older command is removed from the list.
setopt HIST_IGNORE_SPACE        # Remove command lines from the history list when the first character on the line is a space.
setopt HIST_VERIFY              # Whenever the user enters a line with history expansion, don’t execute the line directly.
setopt INC_APPEND_HISTORY       # This option works like APPEND_HISTORY except that new history lines are added to the $HISTFILE incrementally.
setopt LIST_AMBIGUOUS           # This option works when AUTO_LIST or BASH_AUTO_LIST is also set. If there is an unambiguous prefix to insert on the command line.
setopt LIST_PACKED              # Try to make the completion list smaller (occupying less lines) by printing the matches in columns with different widths.
setopt LIST_TYPES               # When listing files that are possible completions, show the type of each file with a trailing identifying mark.
setopt PROMPT_SUBST             # If set, parameter expansion, command substitution and arithmetic expansion are performed in prompts.
setopt SHARE_HISTORY            # This option both imports new commands from the history file, and also causes your typed commands to be appended to the history file.

###############################################################################
#
# Key bindings
#
###############################################################################
bindkey -e
bindkey ^R history-incremental-search-backward 
bindkey ^S history-incremental-search-forward
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[3~" delete-char
bindkey "^[[F" end-of-line
bindkey "^[[H" beginning-of-line

###############################################################################
#
#     Alias Setup
#
###############################################################################

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#     neovim specific aliases
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
alias nve="$EDITOR"
alias nve.alacritty="nve $CONFIG/nvim/alacritty/alacritty.toml"
alias nve.init.lua="nve $CONFIG/nvim/init.lua"
alias nve.starship="nve $CONFIG/starship/starship.toml"
alias nve.waybar.mod.json="nve $CONFIG/waybar/modules.json"
alias nve.zshrc="nve $HOME/.zshrc"


alias goto.files="cd $HOME/git-repositories/github/cbuttars-git/.dotfiles"
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#			Misc. one off aliases
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
alias shopt="/usr/bin/shopt"

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#   My Docker Container Specific aliases
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
alias dock.create.mssql_01="$HOME/git-repositories/github/cbuttars-git/docker_files/create_rojovida_development_mss_database.sh"
alias dock.delete.mssql_01="$HOME/git-repositories/github/cbuttars-git/docker_files/delete_rojovida_development_mss_database.sh"
alias dock.create.postgress_01="$HOME/git-repositories/github/cbuttars-git/docker_files/create_rojovida_development_postgress_database.sh"
alias dock.delete.postgress_01="$HOME/git-repositories/github/cbuttars-git/docker_files/delete_rojovida_development_postgress_database.sh"
alias dock.ps="docker ps --all"

#list
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -alFh'
alias l='ls'
alias l.="ls -A | egrep '^\.'"
alias listdir="ls -d */ > list"

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#     pacman aliases for software managment
#
#     TODO Clean this mess up
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
alias pacman="sudo pacman --color auto"
alias update="sudo pacman -Syyu"
alias upd="sudo pacman -Syyu"
alias sps='sudo pacman -S'
alias spr='sudo pacman -R'
alias sprs='sudo pacman -Rs'
alias sprdd='sudo pacman -Rdd'
alias spqo='sudo pacman -Qo'
alias spsii='sudo pacman -Sii'

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#     pacman aliases for possible miss-spelling
#
#     TODO I don't like this and I think using my "." dot notation
#     will remove the need for these.
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
alias udpate='sudo pacman -Syyu'
alias upate='sudo pacman -Syyu'
alias updte='sudo pacman -Syyu'
alias updqte='sudo pacman -Syyu'
alias upqll='paru -Syu --noconfirm'
alias upal='paru -Syu --noconfirm'

# paru as aur helper - updates everything
alias pksyua="paru -Syu --noconfirm"
alias upall="paru -Syu --noconfirm"
alias upa="paru -Syu --noconfirm"


#fix obvious typo's
alias cd..='cd ..'
alias pdw='pwd'

alias depends='function_depends'

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

#readable output
alias df='df -h'

#keyboard
alias give-me-azerty-be="sudo localectl set-x11-keymap be"
alias give-me-qwerty-us="sudo localectl set-x11-keymap us"

#setlocale
alias setlocale="sudo localectl set-locale LANG=en_US.UTF-8"
alias setlocales="sudo localectl set-x11-keymap be && sudo localectl set-locale LANG=en_US.UTF-8"

#pacman unlock
alias unlock="sudo rm /var/lib/pacman/db.lck"
alias rmpacmanlock="sudo rm /var/lib/pacman/db.lck"

#arcolinux logout unlock
alias rmlogoutlock="sudo rm /tmp/arcologout.lock"

#which graphical card is working
alias whichvga="/usr/local/bin/arcolinux-which-vga"

#free
alias free="free -mt"

#continue download
alias wget="wget -c"

#userlist
alias userlist="cut -d: -f1 /etc/passwd | sort"

#merge new settings
alias merge="xrdb -merge ~/.Xresources"

alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

#add new fonts
alias update-fc='sudo fc-cache -fv'

#switch between bash and zsh
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

#switch between displaymanager or bootsystem
alias toboot="sudo /usr/local/bin/arcolinux-toboot"
alias togrub="sudo /usr/local/bin/arcolinux-togrub"
alias torefind="sudo /usr/local/bin/arcolinux-torefind"
alias tolightdm="sudo pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings --noconfirm --needed ; sudo systemctl enable lightdm.service -f ; echo 'Lightm is active - reboot now'"
alias tosddm="sudo pacman -S sddm --noconfirm --needed ; sudo systemctl enable sddm.service -f ; echo 'Sddm is active - reboot now'"
alias toly="sudo pacman -S ly --noconfirm --needed ; sudo systemctl enable ly.service -f ; echo 'Ly is active - reboot now'"
alias togdm="sudo pacman -S gdm --noconfirm --needed ; sudo systemctl enable gdm.service -f ; echo 'Gdm is active - reboot now'"
alias tolxdm="sudo pacman -S lxdm --noconfirm --needed ; sudo systemctl enable lxdm.service -f ; echo 'Lxdm is active - reboot now'"

# kill commands
# quickly kill conkies
alias kc='killall conky'
# quickly kill polybar
alias kp='killall polybar'
# quickly kill picom
alias kpi='killall picom'

#hardware info --short
alias hw="hwinfo --short"

#audio check pulseaudio or pipewire
alias audio="pactl info | grep 'Server Name'"

#skip integrity check
alias paruskip='paru -S --mflags --skipinteg'
alias yayskip='yay -S --mflags --skipinteg'
alias trizenskip='trizen -S --skipinteg'

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

#approximation of how old your hardware is
alias howold="sudo lshw | grep -B 3 -A 8 BIOS"

#check cpu
alias cpu="cpuid -i | grep uarch | head -n 1"

#get fastest mirrors in your neighborhood
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 30 --number 10 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 30 --number 10 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 30 --number 10 --sort age --save /etc/pacman.d/mirrorlist"
#our experimental - best option for the moment
alias mirrorx="sudo reflector --age 6 --latest 20  --fastest 20 --threads 5 --sort rate --protocol https --save /etc/pacman.d/mirrorlist"
alias mirrorxx="sudo reflector --age 6 --latest 20  --fastest 20 --threads 20 --sort rate --protocol https --save /etc/pacman.d/mirrorlist"
alias ram='rate-mirrors --allow-root --disable-comments arch | sudo tee /etc/pacman.d/mirrorlist'
alias rams='rate-mirrors --allow-root --disable-comments --protocol https arch  | sudo tee /etc/pacman.d/mirrorlist'

#mounting the folder Public for exchange between host and guest on virtualbox
alias vbm="sudo /usr/local/bin/arcolinux-vbox-share"

#enabling vmware services
alias start-vmware="sudo systemctl enable --now vmtoolsd.service"
alias vmware-start="sudo systemctl enable --now vmtoolsd.service"
alias sv="sudo systemctl enable --now vmtoolsd.service"

#youtube download
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4 "

#Recent Installed Packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"
alias riplong="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -3000 | nl"

#iso and version used to install ArcoLinux
alias iso="cat /etc/dev-rel | awk -F '=' '/ISO/ {print $2}'"
alias isoo="cat /etc/dev-rel"

#Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# This will generate a list of explicitly installed packages
alias list="sudo pacman -Qqe"
#This will generate a list of explicitly installed packages without dependencies
alias listt="sudo pacman -Qqet"
# list of AUR packages
alias listaur="sudo pacman -Qqem"
# add > list at the end to write to a file

# install packages from list
# pacman -S --needed - < my-list-of-packages.txt

#clear
alias clean="clear; seq 1 $(tput cols) | sort -R | sparklines | lolcat"

#search content with ripgrep
alias rg="rg --sort path"

#get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

#nano for important configuration files
#know what you do in these files
alias nlxdm="sudo $EDITOR /etc/lxdm/lxdm.conf"
alias nlightdm="sudo $EDITOR /etc/lightdm/lightdm.conf"
alias npacman="sudo $EDITOR /etc/pacman.conf"
alias ngrub="sudo $EDITOR /etc/default/grub"
alias nconfgrub="sudo $EDITOR /boot/grub/grub.cfg"
alias nmakepkg="sudo $EDITOR /etc/makepkg.conf"
alias nmkinitcpio="sudo $EDITOR /etc/mkinitcpio.conf"
alias nmirrorlist="sudo $EDITOR /etc/pacman.d/mirrorlist"
alias narcomirrorlist="sudo $EDITOR /etc/pacman.d/arcolinux-mirrorlist"
alias nsddm="sudo $EDITOR /etc/sddm.conf"
alias nsddmk="sudo $EDITOR /etc/sddm.conf.d/kde_settings.conf"
alias nfstab="sudo $EDITOR /etc/fstab"
alias nnsswitch="sudo $EDITOR /etc/nsswitch.conf"
alias nsamba="sudo $EDITOR /etc/samba/smb.conf"
alias ngnupgconf="sudo $EDITOR /etc/pacman.d/gnupg/gpg.conf"
alias nhosts="sudo $EDITOR /etc/hosts"
alias nhostname="sudo $EDITOR /etc/hostname"
alias nresolv="sudo $EDITOR /etc/resolv.conf"
alias nb="$EDITOR ~/.bashrc"
alias nz="$EDITOR ~/.zshrc"
alias nf="$EDITOR ~/.config/fish/config.fish"
alias nneofetch="$EDITOR ~/.config/neofetch/config.conf"
alias nplymouth="sudo $EDITOR /etc/plymouth/plymouthd.conf"
alias nvconsole="sudo $EDITOR /etc/vconsole.conf"
alias nenvironment="sudo $EDITOR /etc/environment"
alias nloader="sudo $EDITOR /boot/efi/loader/loader.conf"

#reading logs with bat
alias lcalamares="bat /var/log/Calamares.log"
alias lpacman="bat /var/log/pacman.log"
alias lxorg="bat /var/log/Xorg.0.log"
alias lxorgo="bat /var/log/Xorg.0.log.old"

#gpg
#verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
alias fix-gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
#receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"
alias fix-keyserver="[ -d ~/.gnupg ] || mkdir ~/.gnupg ; cp /etc/pacman.d/gnupg/gpg.conf ~/.gnupg/ ; echo 'done'"

#fixes
alias fix-permissions="sudo chown -R $USER:$USER ~/.config ~/.local"
alias keyfix="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias key-fix="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias keys-fix="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fixkey="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fixkeys="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fix-key="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fix-keys="/usr/local/bin/arcolinux-fix-pacman-databases-and-keys"
alias fix-pacman-conf="/usr/local/bin/arcolinux-fix-pacman-conf"
alias fix-pacman-keyserver="/usr/local/bin/arcolinux-fix-pacman-gpg-conf"
alias fix-grub="/usr/local/bin/arcolinux-fix-grub"
alias fixgrub="/usr/local/bin/arcolinux-fix-grub"

#maintenance
alias big="expac -H M '%m\t%n' | sort -h | nl"
alias downgrada="sudo downgrade --ala-url https://ant.seedhost.eu/arcolinux/"

#hblock (stop tracking with hblock)
#use unhblock to stop using hblock
alias unhblock="hblock -S none -D none"

#systeminfo
alias probe="sudo -E hw-probe -all -upload"
alias sysfailed="systemctl list-units --failed"

#shutdown or reboot
alias ssn="sudo shutdown now"
alias sr="reboot"

#update betterlockscreen images
alias bls="betterlockscreen -u /usr/share/backgrounds/arcolinux/"

#give the list of all installed desktops - xsessions desktops
alias xd="ls /usr/share/xsessions"
alias xdw="ls /usr/share/wayland-sessions"

#give a list of the kernels installed
alias kernel="ls /usr/lib/modules"
alias kernels="ls /usr/lib/modules"

#am I on grub,systemd-boot or refind
alias boot="/usr/local/bin/arcolinux-boot"

#wayland aliases
alias wsimplescreen="wf-recorder -a"
alias wsimplescreenrecorder="wf-recorder -a -c h264_vaapi -C aac -d /dev/dri/renderD128 --file=recording.mp4"
alias sshot="$MY_BASH_SCRIPTS/area-screenshot.sh"

#btrfs aliases
alias btrfsfs="sudo btrfs filesystem df /"
alias btrfsli="sudo btrfs su li / -t"

#snapper aliases
alias snapcroot="sudo snapper -c root create-config /"
alias snapchome="sudo snapper -c home create-config /home"
alias snapli="sudo snapper list"
alias snapcr="sudo snapper -c root create"
alias snapch="sudo snapper -c home create"

#arcolinux applications
#att is a symbolic link now
alias adt="arcolinux-desktop-trasher"
alias abl="arcolinux-betterlockscreen"
alias agm="arcolinux-get-mirrors"
alias amr="arcolinux-mirrorlist-rank-info"
alias aom="arcolinux-osbeck-as-mirror"
alias ars="arcolinux-reflector-simple"
alias atm="arcolinux-tellme"
alias avs="arcolinux-vbox-share"
alias awa="arcolinux-welcome-app"

#pamac
alias pamac-unlock="sudo rm /var/tmp/pamac/dbs/db.lock"

#moving your personal files and folders from /personal to ~
alias personal='cp -Rf /personal/* ~'

# -----------------------------------------------------
# ALIASES from original bashrc file
# -----------------------------------------------------

alias c='clear'
alias nf='neofetch'
alias pf='pfetch'
alias ls='eza -a --icons'
alias ll='eza -al --icons'
alias lt='eza -a --tree --level=1 --icons'
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
# [CSB] I want vim to be vim.
# alias vim='$EDITOR'
alias ts='~/dotfiles/scripts/snapshot.sh'
alias matrix='cmatrix'
alias wifi='nmtui'
alias od='~/private/onedrive.sh'
alias rw='~/dotfiles/waybar/reload.sh'
alias winclass="xprop | grep 'CLASS'"
alias dot="cd ~/dotfiles"
alias cleanup='~/dotfiles/scripts/cleanup.sh'
alias ml4w='~/dotfiles/apps/ML4W_Welcome-x86_64.AppImage'
alias ml4w-settings='~/dotfiles/apps/ML4W_Dotfiles_Settings-x86_64.AppImage'

# -----------------------------------------------------
# GIT
# -----------------------------------------------------

alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias gcheck="git checkout"
alias grh="git reset --hard"
alias rmgitcache="rm -r ~/.cache/git"
alias gcredential="git config credential.helper store"
alias gitchris='git config --local user.name "Christopher S. Buttars"'
alias gitgmail='git config --local user.email "chrisbuttars@gmail.com"'
alias gityahoo='git config --local user.email "chrisbuttars@yahoo.com"'
alias gityahoo='git config --local user.email "chrisbuttars@yahoo.com"'
alias gitlive='git config --local user.email "chrisbuttars@live.com"'

# -----------------------------------------------------
# SCRIPTS
# -----------------------------------------------------

alias gr='python ~/dotfiles/scripts/growthrate.py'
alias ChatGPT='python ~/mychatgpt/mychatgpt.py'
alias chat='python ~/mychatgpt/mychatgpt.py'
alias ascii='~/dotfiles/scripts/figlet.sh'

# -----------------------------------------------------
# VIRTUAL MACHINE
# -----------------------------------------------------

alias vm='~/private/launchvm.sh'
alias lg='~/dotfiles/scripts/looking-glass.sh'

# -----------------------------------------------------
# EDIT CONFIG FILES
# -----------------------------------------------------

alias confp='$EDITOR ~/dotfiles/picom/picom.conf'
alias confb='$EDITOR ~/dotfiles/.zshrc'

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------

alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
#grub issue 08/2022
alias install-grub-efi="sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ArcoLinux"

# -----------------------------------------------------
# DEVELOPMENT
# -----------------------------------------------------
alias dotsync="~/dotfiles-versions/dotfiles/.dev/sync.sh dotfiles"

# -----------------------------------------------------
# PYWAL
# -----------------------------------------------------
# cat ~/.cache/wal/sequences

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#
###############################################################################
#
#     Local Functions
#
###############################################################################
_fzf_compgen_path() {
    fd --hidden --follow . "$1"
}
_fzf_compgen_dir() {
    fd --type d --hidden --follow . "$1"
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#     show the list of packages that need this package 
#     example function_depends mpv as example
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function_depends()  {
    search=$(echo "$1")
    sudo pacman -Sii $search | grep "Required" | sed -e "s/Required By     : //g" | sed -e "s/  /\n/g"
    }

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#     EXtractor for all kinds of archives
#     usage: ex <file>
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#    yadm commit function as psuedo alias
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
yadm_commit() {
  y commit -am $1
}
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
#    yadm add function as psuedo alias
#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
yadm_add(){
  y add $1
}

[ -s ~/.luaver/luaver ] && . ~/.luaver/luaver
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
