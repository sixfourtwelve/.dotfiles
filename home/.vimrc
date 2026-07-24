set nocompatible

let loaded_matchparen = 1

filetype plugin indent on

call plug#begin()
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-commentary'
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mbbill/undotree'
Plug 'rhysd/vim-clang-format'
Plug 'jiangmiao/auto-pairs'
call plug#end()

syntax off
set termguicolors
colorscheme default

highlight Normal     ctermbg=NONE guibg=NONE
highlight VertSplit  cterm=NONE ctermfg=NONE ctermbg=NONE gui=NONE guifg=NONE guibg=NONE

hi Pmenu       cterm=NONE ctermfg=15 ctermbg=0  gui=NONE guifg=#E8E8E8 guibg=#0A0A0A
hi PmenuSel    cterm=NONE ctermfg=0  ctermbg=7  gui=NONE guifg=#0A0A0A guibg=#AAAAAA
hi PmenuSbar   cterm=NONE ctermfg=0  ctermbg=0  gui=NONE guifg=#0A0A0A guibg=#111111
hi PmenuThumb  cterm=NONE ctermfg=15 ctermbg=15 gui=NONE guifg=#AAAAAA guibg=#AAAAAA
hi NormalFloat  cterm=NONE ctermfg=15 ctermbg=0  gui=NONE guifg=#E8E8E8 guibg=#0A0A0A
hi CocFloating  cterm=NONE ctermfg=15 ctermbg=0  gui=NONE guifg=#E8E8E8 guibg=#0A0A0A
hi FloatBorder  cterm=NONE ctermfg=8  ctermbg=0  gui=NONE guifg=#444444 guibg=#0A0A0A
hi SignColumn   cterm=NONE ctermfg=NONE ctermbg=NONE
hi TabLineFill  cterm=NONE ctermfg=NONE ctermbg=NONE
hi CocListSearch cterm=NONE ctermfg=15 ctermbg=0 gui=NONE guifg=#E8E8E8 guibg=#0A0A0A
hi CocSearch     cterm=NONE ctermfg=15 ctermbg=0 gui=NONE guifg=#E8E8E8 guibg=#0A0A0A

set encoding=utf-8
set termencoding=utf-8
set mouse=a
set noshowmode
" bloat
set signcolumn=no
set nonumber
set showtabline=0
set ignorecase
set re=0
" status lines are for chumps
set laststatus=0
set dir=/tmp
set backupdir=/tmp
" yanking actually goes to the clipboard
set clipboard^=unnamed
set notimeout
set ttimeout
set timeoutlen=100
set guioptions-=e
set fillchars=vert:│,fold:┈,diff:┈

" swap files keep getting put side by side, how about fuck off
if has("persistent_undo")
  let s:undodir = expand('~/.undodir')
  if !isdirectory(s:undodir)
    call mkdir(s:undodir, "p", 0700)
  endif
  let &undodir = s:undodir
  set undofile
endif

let mapleader      = " "
let maplocalleader = " "

set tabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set cindent

augroup FileTypeIndent
  autocmd!
  autocmd FileType cpp,objc,objcpp  setlocal sw=4 ts=4 et
  autocmd FileType c setlocal sw=4 ts=4 et
  autocmd FileType cs,zig,fsharp      setlocal sw=2 ts=2 et
  autocmd FileType go,odin            setlocal sw=8 ts=8 noet
  autocmd FileType ada                setlocal sw=3 ts=3 et
  autocmd FileType yaml               setlocal sw=2 ts=2 et
  autocmd FileType sh,bash            setlocal sw=2 ts=2 noet
augroup END

" I say when to format
let g:clang_format#auto_format = 0

nnoremap <C-w><Left>  <C-w>h
nnoremap <C-w><Right> <C-w>l
nnoremap <C-w><Up>    <C-w>k
nnoremap <C-w><Down>  <C-w>j

" swap between buffers easily, don't fancy typing bprev/bnext manually
nnoremap <C-a> :bprev<CR>zz
nnoremap <C-s> :bnext<CR>zz

" file tree to make my life a tiny bit easier, but not used all that much
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
let NERDTreeIgnore=['\.vim$', '\~$', 'external', 'out', 'build', 'node_modules']
let g:NERDTreeNodeDelimiter = "\u00a0"
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-t> :NERDTree<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" global file search because using grep can only get me so far
let g:ctrlp_open_new_file = 'v'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,external,build,out

function! CheckBackspace() abort
    let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Use arrow keys to move in CoC popup menu
inoremap <expr> <Down> coc#pum#visible() ? coc#pum#next(1) : "\<Down>"
inoremap <expr> <Up>   coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"


inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>""

nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)
nmap <silent><nowait> rn <Plug>(coc-rename)
nmap <silent><nowait> ac <Plug>(coc-codeaction-cursor)

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

nnoremap <silent> K :call ShowDocumentation()<CR>

" spill the tea on function docs, please and thank you
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction


" fucking continuation bollocks, makes copy pasting code tragically bad
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

