# Interactive shell config.
#
# Almost everything now lives in conf.d/, which fish sources automatically
# and in filename order, before this file:
#
#   00-path.fish        PATH and toolchains
#   10-env.fish         environment
#   20-git-aliases.fish git aliases
#   25-svn-aliases.fish svn/cvs aliases
#   secrets.fish        machine-local, untracked
#
# Keep this file for things that must run last, or only when interactive.

set fish_greeting

# Was commented out for as long as ~/.config/starship.toml has existed; the
# formula is in packages/bundle now, so the configured prompt actually runs.
starship init fish | source
