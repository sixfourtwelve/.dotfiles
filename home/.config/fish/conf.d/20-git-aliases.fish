# git aliases.
#
# gc/gca/gts/gtv sign. That needs a GPG key and commit.gpgsign — `dot
# gen-gpg-key` sets both up, and `dot doctor` fails if they go missing.

alias gst='git status'
alias gaa='git add -A'
alias gc='git commit -S'
alias gca='git commit -S --amend'
alias gct='git checkout trunk'
alias gcms='git checkout master'
alias gcm='git checkout main'
alias gd='git diff'
alias gdc='git diff --cached'
alias co='git checkout'
alias up='git push'
alias upf='git push --force'
alias pu='git pull'
alias pur='git pull --rebase'
alias fe='git fetch'
alias re='git rebase'
alias lr='git l -30'
alias cdr='cd $(git rev-parse --show-toplevel)' # cd to git root
alias hs='git rev-parse --short HEAD'
alias hm='git log --format=%B -n 1 HEAD'
alias gts='git tag -s'
alias gtv='git tag -v'
