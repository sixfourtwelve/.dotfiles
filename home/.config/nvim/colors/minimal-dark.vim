set background=dark
highlight clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "minimal-dark"

" Core UI highlight groups
hi! StatusLine    ctermfg=black ctermbg=NONE guifg=#000000 guibg=NONE
hi! StatusLineNC  ctermfg=black ctermbg=NONE guifg=#000000 guibg=NONE
hi! Normal        ctermbg=NONE               guibg=NONE
hi! Special       ctermfg=cyan               guifg=#00ffff
hi! LineNr        ctermfg=black ctermbg=NONE guifg=#000000 guibg=NONE
hi! SpecialKey    ctermfg=black ctermbg=NONE guifg=#000000 guibg=NONE
hi! ModeMsg       ctermfg=black ctermbg=NONE guifg=#000000 guibg=NONE gui=NONE
hi! MoreMsg       ctermfg=black ctermbg=NONE guifg=#000000 guibg=NONE
hi! NonText       ctermfg=black ctermbg=NONE guifg=#000000 guibg=NONE
hi! vimGlobal     ctermfg=black ctermbg=NONE guifg=#000000 guibg=NONE
hi! Comment       ctermfg=black ctermbg=NONE guifg=#000000 guibg=NONE
hi! ErrorMsg      ctermbg=234  ctermfg=darkred guibg=#1c1c1c guifg=#8b0000 gui=NONE
hi! Error         ctermbg=234  ctermfg=darkred guibg=#1c1c1c guifg=#8b0000 gui=NONE
hi! SpellBad      ctermbg=234  ctermfg=darkred guibg=#1c1c1c guifg=#8b0000 gui=NONE
hi! SpellRare     ctermbg=234  ctermfg=darkred guibg=#1c1c1c guifg=#8b0000 gui=NONE
hi! Search        ctermbg=236  ctermfg=darkred guibg=#303030 guifg=#8b0000
hi! vimTodo       ctermbg=236  ctermfg=darkred guibg=#303030 guifg=#8b0000
hi! Todo          ctermbg=236  ctermfg=darkred guibg=#303030 guifg=#8b0000
hi! IncSearch     ctermbg=236  ctermfg=darkred guibg=#303030 guifg=#8b0000 gui=NONE
hi! MatchParen    ctermbg=236  ctermfg=darkred guibg=#303030 guifg=#8b0000
hi! WinBar        ctermfg=black ctermbg=NONE guifg=#000000 guibg=NONE gui=NONE
hi! SignColumn    ctermbg=NONE               guibg=NONE
hi! TabLineFill   guibg=#121111 guifg=#000000 ctermbg=233 ctermfg=black

" Pmenu and float colors
hi! Pmenu         ctermfg=0  ctermbg=2  guibg=#121212
hi! PmenuSel      ctermfg=15 ctermbg=2  guibg=#121212
hi! NormalFloat   gui=NONE guibg=#121212
hi! CocFloating   gui=NONE guibg=#121212
hi! FloatBorder   guifg=#5c6370 guibg=NONE

" Syntax highlighting groups - match Vim defaults
hi! Constant      ctermfg=3   guifg=#FFFF00
hi! String        ctermfg=1   guifg=#FF6B6B
hi! Character     ctermfg=1   guifg=#FF6B6B
hi! Number        ctermfg=3   guifg=#FFFF00
hi! Boolean       ctermfg=3   guifg=#FFFF00
hi! Float         ctermfg=3   guifg=#FFFF00

hi! Identifier    ctermfg=2   guifg=#00FF00
hi! Function      ctermfg=2   guifg=#00FF00

hi! Statement     ctermfg=2   guifg=#00FF00
hi! Conditional   ctermfg=2   guifg=#00FF00
hi! Repeat        ctermfg=2   guifg=#00FF00
hi! Label         ctermfg=2   guifg=#00FF00
hi! Operator      ctermfg=3   guifg=#FFFF00
hi! Keyword       ctermfg=2   guifg=#00FF00
hi! Exception     ctermfg=1   guifg=#FF6B6B

hi! PreProc       ctermfg=1   guifg=#FF6B6B
hi! Include       ctermfg=1   guifg=#FF6B6B
hi! Define        ctermfg=1   guifg=#FF6B6B
hi! Macro         ctermfg=1   guifg=#FF6B6B
hi! PreCondit     ctermfg=1   guifg=#FF6B6B

hi! Type          ctermfg=2   guifg=#00FF00
hi! StorageClass  ctermfg=2   guifg=#00FF00
hi! Structure     ctermfg=2   guifg=#00FF00
hi! Typedef       ctermfg=2   guifg=#00FF00

hi! Underlined    cterm=underline gui=underline ctermfg=6 guifg=#00FFFF

" Links
hi! link ocamlKwErr Statement

" FileType specific overrides
augroup MinimalDarkColorScheme
    autocmd!
    au FileType * hi! StatusLine ctermfg=black ctermbg=NONE
    au FileType * hi! StatusLineNC ctermfg=black ctermbg=NONE
    au FileType * hi! Normal ctermbg=NONE
    au FileType * hi! Special ctermfg=cyan
    au FileType * hi! LineNr ctermfg=black ctermbg=NONE
    au FileType * hi! SpecialKey ctermfg=black ctermbg=NONE
    au FileType * hi! ModeMsg ctermfg=black cterm=NONE ctermbg=NONE
    au FileType * hi! MoreMsg ctermfg=black ctermbg=NONE
    au FileType * hi! NonText ctermfg=black ctermbg=NONE
    au FileType * hi! vimGlobal ctermfg=black ctermbg=NONE
    au FileType * hi! Comment ctermfg=black ctermbg=NONE
    au FileType * hi! ErrorMsg ctermbg=234 ctermfg=darkred cterm=NONE
    au FileType * hi! Error ctermbg=234 ctermfg=darkred cterm=NONE
    au FileType * hi! SpellBad ctermbg=234 ctermfg=darkred cterm=NONE
    au FileType * hi! SpellRare ctermbg=234 ctermfg=darkred cterm=NONE
    au FileType * hi! Search ctermbg=236 ctermfg=darkred
    au FileType * hi! vimTodo ctermbg=236 ctermfg=darkred
    au FileType * hi! Todo ctermbg=236 ctermfg=darkred
    au FileType * hi! MatchParen ctermbg=236 ctermfg=darkred
    au FileType markdown,pandoc hi! Title ctermfg=yellow ctermbg=NONE
    au FileType markdown,pandoc hi! Operator ctermfg=yellow ctermbg=NONE
    au FileType markdown,pandoc set tw=0
    au FileType markdown,pandoc set wrap
    au FileType yaml hi! yamlBlockMappingKey ctermfg=NONE
    au FileType yaml set sw=2
    au FileType sh,bash set sw=2
    au FileType c set sw=8
    au FileType markdown,pandoc,asciidoc noremap j gj
    au FileType markdown,pandoc,asciidoc noremap k gk
    au FileType sh,bash set noet
augroup END
