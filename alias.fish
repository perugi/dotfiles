# Program aliases
alias python=python3
alias pip=pip3
alias v=vim

# Shorthands for common commands
abbr -a gs  git status -sb
abbr -a ga  git add
abbr -a gc  git commit
abbr -a gcm git commit -m
abbr -a gca git commit --amend
abbr -a gcl git clone
abbr -a gp  git push
abbr -a gpl git pull
abbr -a gd  git diff
abbr -a gds git diff --staged
abbr -a gr  git rebase -i HEAD~15
abbr -a gf  git fetch
abbr -a gco git checkout
abbr -a gb  git branch
abbr -a gl  git log --all --graph --decorate --abbrev-commit
abbr -a glo git log --all --graph --decorate --abbrev-commit --oneline

abbr -a cl   clear
abbr -a cd   z
abbr -a ..   z ..
abbr -a ...  z ../..
abbr -a .... z ../../..
abbr -a chx  chmod u+x
abbr -a ls   exa
abbr -a ll   exa -alF
abbr -a la   exa -A

abbr -a activate source venv/bin/activate

# Default options for commands 
alias mv="mv -i"		# prompts before overwrite
alias mkdir="mkdir -p"	# make parent dirs as needed
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Common misspelings
abbr -a dc z
abbr -a sl exa


