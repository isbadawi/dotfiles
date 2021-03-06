execute pathogen#infect('bundle/{}', 'bundle-manual/{}')
filetype plugin on
filetype plugin indent on
syntax on

set t_BE=
set t_Co=256
colorscheme wombat256
" wombat defines ctermbg=234; under iTerm2 2.1.4 this mapped to #262626, but
" under iTerm2 3.0 it maps to #1c1c1c, which is noticeably darker. I guess
" #1c1c1c is what it was supposed to be all along, but at this point I'm too
" used to how it looked under 2.1.4. So set ctermbg=235, which maps to #262626
" under 3.0.
"
" See http://stackoverflow.com/a/33517512/281108 for context.
" Also https://gitlab.com/gnachman/iterm2/issues/4226 is somewhat related.
"
" I could put a conditional on $TERM_PROGRAM / $TERM_PROGRAM_VERSION here,
" but then I'd have to forward those variables to any ssh sessions, which is
" not convenient.
highlight Normal ctermfg=254 ctermbg=235 cterm=none
" Make searches underline instead of highlight
highlight Search ctermbg=235 ctermfg=NONE cterm=underline
highlight IncSearch ctermbg=235 ctermfg=NONE cterm=underline
" Misc. changes to line up with wombat
highlight LineNr ctermbg=235
highlight NonText ctermbg=235

" This makes the ruby block text object plugin work
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

set nocompatible
" Don't create .swp files
set noswapfile
" Turn off folding
set foldmethod=manual
set nofoldenable
" Display current line/column at the bottom
set ruler
" Use relative line numbers
set relativenumber
" Indent by two spaces, use two-space tabs
set autoindent
set shiftwidth=2 tabstop=2 softtabstop=2 expandtab
" Briefly jump to matching paren/bracket/brace after typing one
set showmatch
" Show incremental matches when searching with / or ?
set incsearch
" Make search case insensitive unless there's an uppercase in the query
set ignorecase smartcase
" Make backspace sane
set backspace=eol,indent,start
" Allow moving around everywhere, even past ends of lines
set virtualedit=all
" Automatically read file if it's been changed outside of vim
set autoread
" Less prompts about unsaved changes
set hidden
" Don't insert two spaces after punctuation when joining lines with J or gq
set nojoinspaces
" Run external commands with bash
set shell=bash
" Find ctags files in parent directories, not just current
set tags=./tags;/
" remember more than the default 50 lines per register on quit
set viminfo='50,<1000,s100,h
" Use ag instead of grep for :grep (if available)
if executable('ag')
  set grepprg=ag\ --smart-case\ --nogroup\ --nocolor
endif
" Open horizontal splits below by default
set splitbelow
" Open vertical splits to the right by default
set splitright
" Ensure enough room in windows for 80 characters plus line numbers
" (but don't mess with split sizes if invoked as vimdiff)
if &diff == 0
  set winwidth=83
endif

augroup filetypes
  autocmd!
  " Use Java syntax for JastAdd
  autocmd BufNewFile,BufRead *.jadd,*jrag set filetype=java
  " In lex, make and go, tabs are significant
  autocmd FileType lex,make,go setlocal noexpandtab
  " Use four spaces for python as per pep 8
  autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4
  " Use // comments for C/C++ files (for commentary plugin)
  autocmd FileType c,cc,cpp setlocal commentstring=//\ %s
  autocmd FileType matlab setlocal commentstring=%\ %s
  " Have gf try with these suffixes if it can't find a path
  " (vim sets this by itself for some filetypes (e.g. py, rb, java))
  autocmd FileType javascript setlocal suffixesadd=.js
  autocmd FileType tex setlocal suffixesadd=.tex
augroup END

augroup remember_position
  autocmd!
  " This makes files open at the same line they were closed
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
augroup END

" Highlight line under cursor, but not in insert mode
set cursorline
augroup cline
  autocmd!
  autocmd InsertEnter * set nocursorline
  autocmd InsertLeave * set cursorline
augroup END

" :w!! to sudo write a file
cnoremap w!! w !sudo tee % > /dev/null

" Swap j and gj, k and gk
" Usually j goes down numbered lines, while gj goes down display lines
" (n.b. Another difference is that j & k are linewise, but gj & gk are
" characterwise...)
" (n.b. These are noremap, not nnoremap, so that they'll also apply to
" operator pending mode and visual mode.)
noremap j gj
noremap k gk
noremap gj j
noremap gk k

let mapleader=","
let maplocalleader="\\"

" Quickly get at commonly edited files
nnoremap <leader>ov :edit ~/.vimrc<cr>
nnoremap <leader>rv :source ~/.vimrc<cr>
nnoremap <leader>ob :edit ~/.bashrc<cr>
nnoremap <leader>og :edit ~/.gitconfig<cr>

" Pressing <cr> dismisses highlights
nnoremap <cr> :set nohlsearch<cr>
" Turn highlighting back on before searching
nnoremap / :set hlsearch<cr>/
nnoremap ? :set hlsearch<cr>?

" In the command window (q:, q/, q?), <cr> runs commands or searches
" so make sure it still works there.
augroup cmdwin
  autocmd!
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :nnoremap <cr> :set nohlsearch<cr>
augroup END

" Exit insert mode with jk (and only jk)
inoremap jk <esc>
inoremap <esc> <nop>
" Disable arrow keys
map <left> <nop>
map <right> <nop>
map <up> <nop>
map <down> <nop>

" This makes ,, alternate between the last two files
nnoremap <leader><leader> <c-^>

" Move around windows with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Toggle between relative and absolute line numbers
nnoremap <leader>n :set number! relativenumber!<cr>

nnoremap <leader>w :FixWhitespace<cr>

nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gc :call GstatusOrGcommit()<cr>

" vim-unimpaired style mappings for the jump list
nnoremap [j <C-O>
nnoremap ]j <C-I>

" Call :Gstatus unless it's already open, in which case call :Gcommit
function! GstatusOrGcommit()
  if bufname('%') !~ '.git/index$'
    Gstatus
  else
    Gcommit --verbose
  end
endfunction

" Run a given vim command on the results of fuzzy selecting from a given shell
" command. Adapted from https://github.com/garybernhardt/selecta#use-with-vim
function! SelectaCommand(choice_command, vim_command)
  try
    silent let selection = system(a:choice_command . " | selecta")
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find and open file in current window (e), vsplit (v), or split (s)
nnoremap <leader>e :call SelectaCommand("ag -l", ":e")<cr>
nnoremap <leader>v :call SelectaCommand("ag -l", ":vsp")<cr>
nnoremap <leader>s :call SelectaCommand("ag -l", ":sp")<cr>
" Find ctags entry and jump to it
nnoremap <leader>f :call SelectaCommand("LC_ALL=C cut -f1 tags \| tail +7 \| uniq", ":tag")<cr>
