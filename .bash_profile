#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
if [ -e /home/rejuvyesh/.nix-profile/etc/profile.d/nix.sh ]; then . /home/rejuvyesh/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
