# Environment.

set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"

set -gx EDITOR nvim

set -gx OLLAMA_NUM_PARALLEL 2

test -f ~/.fzf.fish; and source ~/.fzf.fish
