#----------------------------
# Aliases
#----------------------------
alias fixWebShit="sudo sh setWebPermissions -r /Library/WebServer/showcase-website/"
alias mankyWeather="lynx -dump http://www.bbc.co.uk/weather | grep Manchester"
alias cdp="cd ~/Dropbox\ \(DRIFT\ UK\)/Projects/"
alias cdr="cd ~/GitRepos"
alias cdw="cd /Library/WebServer"
alias psg="ps aux | grep -i -e VSZ -e"
alias kilburn="ssh -X a64070ho@kilburn.cs.man.ac.uk"
alias p="python3"
alias python="python3"
alias pip="pip3"
alias you="echo 'no you'"
alias fuck="echo 'yeah, fuck'"

#----------------------------
# Git Aliases
#----------------------------
alias ga="git add"
alias gaa="git add ."
alias gaaa="git add --all"
alias gcm="git commit --message"

#----------------------------
# Helper Functions
#----------------------------
mcdir () { mkdir -p $1; cd $1; }
splitVideo () { ffmpeg -i "$1" "${1%.*}%04d.jpg" -hide_banner; }

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

#----------------------------------------------------------
# Colour
#----------------------------------------------------------

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export CLICOLOR=1
#----------------------------------------------------------
# Setting PATH 
# The original version is saved in .bash_profile.pysave
#----------------------------------------------------------
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH

