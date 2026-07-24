#!/bin/sh
# Claude Code status line — mirrors Starship prompt style
input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
repo=$(echo "$input" | jq -r '.workspace.repo | if . then .owner + "/" + .name else empty end')
branch=$(echo "$input" | jq -r '
  if .worktree.branch then .worktree.branch
  elif .workspace.git_worktree then .workspace.git_worktree
  else empty
  end')

# Truncate branch name to 18 chars (matching starship git_branch.truncation_length)
if [ -n "$branch" ]; then
  if [ ${#branch} -gt 18 ]; then
    branch="${branch%????????????????????????????????}"
    branch="${branch}…"
  fi
fi

# Shorten cwd: replace $HOME with ~
home=$(echo ~)
short_cwd=$(echo "$cwd" | sed "s|^$home|~|")

# Build the status line
line=""

# Directory (cyan/blue, dim-friendly)
line="${line}$(printf '\033[36m%s\033[0m' "$short_cwd")"

# Git branch with  symbol
if [ -n "$branch" ]; then
  line="${line} $(printf '\033[35m %s\033[0m' "$branch")"
fi

# Repo (owner/name) when available and different from branch context
if [ -n "$repo" ]; then
  line="${line} $(printf '\033[2m(%s)\033[0m' "$repo")"
fi

# Model
if [ -n "$model" ]; then
  line="${line} $(printf '\033[33m%s\033[0m' "$model")"
fi

# Context window usage
if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  if [ "$used_int" -ge 80 ]; then
    line="${line} $(printf '\033[31mctx:%s%%\033[0m' "$used_int")"
  elif [ "$used_int" -ge 50 ]; then
    line="${line} $(printf '\033[33mctx:%s%%\033[0m' "$used_int")"
  else
    line="${line} $(printf '\033[2mctx:%s%%\033[0m' "$used_int")"
  fi
fi

# Prompt character — 󰘧 mirrors starship character.success_symbol
line="${line} $(printf '\033[32m󰘧\033[0m')"

printf '%s' "$line"
