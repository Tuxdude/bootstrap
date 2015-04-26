"
" Author: Ash<tuxdude.io@gmail.com>
"

" Execute pathogen right away
execute pathogen#infect()
execute pathogen#helptags()

" Disable compatibility mode (VIM mode)
set nocompatible

" Most terminal emulators have mouse support, enable it
if has('mouse')
  set mouse=a
endif

" Use ',' key as the leader instead of '\'
let mapleader = ','

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Enable filetype plugin
filetype plugin on

" Enable indentation
filetype indent on

" Soft tabs with 4 character width
set expandtab
set shiftwidth=4
set softtabstop=4
set smarttab

" Always display ruler
set ruler

" Enable syntax
syntax enable

" Enable Search highighting
set hlsearch

" Disable the omnicomplete preview window (causes flickering with the
" statusline)
set completeopt-=preview

" Build room in Status line for plugins like airline, powerline to render
" their stuff even in non-split windows
set laststatus=2

" Hide the default mode text below the Status line
set noshowmode

" Set character encoding to UTF8
set encoding=utf-8

" Persist the global variables across sessions
set viminfo+=!

" Enable persistent undo across vim sessions
if has("persistent_undo")
    set undofile
    set undodir=~/.vimundo
endif

" New windows don't cause all windows to be resized to equal sizes
set noequalalways

" Setup for vimdiff
" Call this only in diff mode
func! VimDiffSetup()
    " Set the same filetype for both the diff windows
    if len(&ft)
        call setwinvar(2/winnr(),'&ft',&ft)
    else
        let &ft=getwinvar(2/winnr(),'&ft')
    endif

    " Disable folding in diff mode
    set nofoldenable foldcolumn=0
    wincmd b
    set nofoldenable foldcolumn=0
endfun

" GUI related stuff
if has("gui_running")
    " Diff setup
    if &diff
"        set columns=200

        " Setup on loading vimdiff
        augroup SmartDiffSetup
            autocmd!
            autocmd VimEnter * :call VimDiffSetup()
        augroup END
    else
"        set columns=100
    endif

    " Set GUI Font
    if has('mac')
        set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h12
    elseif has('unix')
        set guifont=DejaVu\ Sans\ Mono\ 11
    else
        " Godsave this OS :P
    endif

    " Set geometry
    set columns=250
    set lines=70
endif

" Set up colorscheme
colorscheme MolokaiSaber

" Enable doxygen for c, cpp and idl files
let g:load_doxygen_syntax = 1
let g:doxygen_enhanced_color = 1

" Disable P4 Active Status
let g:p4EnableActiveStatus = 0

" Disable RST foldoing
augroup DisableRstFolding
    autocmd!
    autocmd Filetype rst setlocal nofoldenable
augroup END

" Set Java syntax highlighting for *.aidl
augroup AidlAsjava
    autocmd!
    autocmd BufReadPost *.aidl set syntax=java
augroup END

" Set Makefile syntax highlighting for *.inc
augroup IncAsMakefiles
    autocmd!
    autocmd BufReadPost *.inc set syntax=make
augroup END

" Set Thrift syntax highlighting for *.thrift
augroup ThriftAsThrift
    autocmd!
    autocmd BufReadPost *.thrift set syntax=thrift
augroup END

" Set Smali syntax highlighting for *.smali
augroup SmaliAsSmali
    autocmd!
    autocmd BufReadPost *.smali set syntax=smali
augroup END

"=============================================================================
"                               BEGIN TMUX
"=============================================================================
if &term =~ '^screen'
    " Extended mouse mode in tmux
    set mouse+=a
    set ttymouse=xterm2

    " tmux sends xterm-style keys when xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
    execute "set <xHome>=\e[1;*H"
    execute "set <xEnd>=\e[1;*F"
    execute "set <Insert>=\e[2;*~"
    execute "set <Delete>=\e[3;*~"
    execute "set <PageUp>=\e[5;*~"
    execute "set <PageDown>=\e[6;*~"
    execute "set <xF1>=\e[1;*P"
    execute "set <xF2>=\e[1;*Q"
    execute "set <xF3>=\e[1;*R"
    execute "set <xF4>=\e[1;*S"
    execute "set <F5>=\e[15;*~"
    execute "set <F6>=\e[17;*~"
    execute "set <F7>=\e[18;*~"
    execute "set <F8>=\e[19;*~"
    execute "set <F9>=\e[20;*~"
    execute "set <F10>=\e[21;*~"
    execute "set <F11>=\e[23;*~"
    execute "set <F12>=\e[24;*~"
endif
"=============================================================================
"                               END TMUX
"=============================================================================

"=============================================================================
"                               BEGIN PLUGINS
"=============================================================================

" CtrlP Plugin stuff
let g:ctrlp_map = '<C-P>'
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_show_hidden = 1
let g:ctrlp_root_markers = ['build.config']
let g:ctrlp_max_height = 25
let g:ctrlp_max_files = 500000
let g:ctrlp_regexp = 1
"let g:ctrlp_user_command = 'find %s ( -type f -o -type l)'
let g:ctrlp_lazy_update = 1
let ctrlp_filter_greps = "".
    \ "egrep -iv '\\.(" .
    \ "jar|class|swp|swo|log|a|d|so|o|pyc|jpe?g|png|gif|mo|po" .
    \ ")$' | " .
    \ "egrep -v '^(\\./)?(" .
    \ "deploy/|lib/|classes/|libs/|deploy/vendor/|.git/|.hg/|.svn/|.*migrations/" .
    \ ")'"
let ctrlp_git_command = "" .
    \ "cd %s && git ls-files . -co --exclude-standard | " .
    \ ctrlp_filter_greps
let ctrlp_fallback_user_command = "" .
    \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*' | " .
    \ ctrlp_filter_greps
let g:ctrlp_user_command = ['.git/', ctrlp_git_command, ctrlp_fallback_user_command]
call ctrlp_bdelete#init()
nnoremap <silent> <C-L> :CtrlP<CR>

" Riv plugin
let g:riv_fold_auto_update = 0

" tagbar plugin
nnoremap <silent> <Leader>t :TagbarToggle<CR>
let g:tagbar_map_prevtag = "<C-M>"

" easytags plugin
let g:easytags_async = 1
let g:easytags_languages = {
\   'javascript': {
\       'cmd': 'jsctags',
\       'args': [],
\       'fileoutput_opt': '-f',
\       'stdout_opt': '-f-',
\       'recurse_flag': '-R'
\   }
\}

" Mark Plugin
let g:mwDefaultHighlightingPalette = 'extended'
let g:mwAutoLoadMarks = 1
let g:mwAutoSaveMarks = 1
nnoremap <Plug>IgnoreMarkSearchNext <Plug>MarkSearchNext
nnoremap <Plug>IgnoreMarkSearchPrev <Plug>MarkSearchPrev

" YouCompleteMe plugin
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" jedi plugin
augroup JediDisablePreviewForPython
    autocmd!
    autocmd FileType python setlocal completeopt-=preview
augroup END

" nerdtree plugin
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
nnoremap <F3> :NERDTreeToggle<CR>

" Indent Guide plugin
let g:indent_guides_auto_colors = 0
let g:indent_guides_start_level = 2
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size=1

" undotree plugin
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_SplitWidth = 25
nnoremap <silent> <Leader>u :UndotreeToggle<CR>

" Airline - Setup using powerline symbols
let g:airline_exclude_preview = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline_theme='powerlineish'
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
"============================================================================
"                               END PLUGINS
"============================================================================

" Source the RPM related goodies
source ~/.vim/.vimrc-rpm.vim

" ~/.vimrc ends here
