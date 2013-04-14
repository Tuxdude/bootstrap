"
" Author: Ash<tuxdude.github@gmail.com>
"

" Execute pathogen as the first
execute pathogen#infect()
execute pathogen#helptags()

" BEGIN DEFAULT OPENSUSE VIMRC
" skeletons
function! SKEL_spec()
    0r /usr/share/vim/current/skeletons/skeleton.spec
    language time en_US
    if $USER != ''
        let login = $USER
    elseif $LOGNAME != ''
        let login = $LOGNAME
    else
        let login = 'unknown'
    endif
    let newline = stridx(login, "\n")
    if newline != -1
        let login = strpart(login, 0, newline)
    endif
    if $HOSTNAME != ''
        let hostname = $HOSTNAME
    else
        let hostname = system('hostname -f')
        if v:shell_error
            let hostname = 'localhost'
        endif
    endif
    let newline = stridx(hostname, "\n")
    if newline != -1
        let hostname = strpart(hostname, 0, newline)
    endif
    exe "%s/specRPM_CREATION_DATE/" . strftime("%a\ %b\ %d\ %Y") . "/ge"
    exe "%s/specRPM_CREATION_AUTHOR_MAIL/" . login . "@" . hostname . "/ge"
    exe "%s/specRPM_CREATION_NAME/" . expand("%:t:r") . "/ge"
    setf spec
endfunction

augroup SpecSetup
    autocmd!
    autocmd BufNewFile *.spec call SKEL_spec()
augroup END

" END DEFAULT OPENSUSE VIMRC

" Enable filetype plugin
filetype plugin on
" Enable indentation
filetype indent on

set gfn=DejaVu\ Sans\ Mono
set expandtab
set shiftwidth=4
set softtabstop=4
set smarttab
set ruler
syntax enable
set hlsearch!

" Taglist plugin
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>

" Rebuild tags
map <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Enable doxygen for c, cpp and idl files
let g:load_doxygen_syntax=1
let g:doxygen_enhanced_color=1

" Disable P4 Active Status
let g:p4EnableActiveStatus=0

" Force .inc files as Makefile syntax highlighting
augroup IncAsMakefiles
    autocmd!
    autocmd BufReadPost *.inc set syntax=make
augroup END

" Setup for vimdiff
" Call this only in diff mode
func VimDiffSetup()
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

if has("gui_running")
    if &diff
        if (match(hostname(), 'WingSaber') >= 0)
            set lines=40 columns=200
        elseif (match(hostname(), 'StarScream') >= 0)
            set gfn=DejaVu\ Sans\ Mono\ 11
            set columns=200
        else
            set columns=200
        endif

        " Setup on loading vimdiff
        augroup SmartDiffSetup
            autocmd!
            autocmd VimEnter * :call VimDiffSetup()
        augroup END
    else
        if (match(hostname(), 'WingSaber') >= 0)
            set lines=40 columns=100
        elseif (match(hostname(), 'StarScream') >= 0)
            set gfn=DejaVu\ Sans\ Mono\ 11
            set columns=100
        else
            set columns=100
        endif
    endif
    colorscheme DesertSaber
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Begin Powerline
"
" Read this documentation
" https://powerline.readthedocs.org/en/latest/
"
" To install:
" Get the Powerline repo from (forked of github.com/Lokaltog/powerline)
" git clone github:Tuxdude/powerline
" or
" git clone git://github.com/Tuxdude/powerline.git
"
" If the destination is different than /data/dev-stuff/github-repos/powerline
" create a symlink to this location
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Load powerline bindings
set rtp+=~/.vim/bundle/powerline/bindings/vim
" To make the powerline status line show up in non-split windows
set laststatus=2
" Hide the default mode text below the Status line
set noshowmode
" Avoid junk characters in the Status line
set fillchars+=stl:\ ,stlnc:\
set encoding=utf-8
" Terminal timeout when pressing Escape key
if ! has('gui_running')
    set ttimeoutlen=10
    augroup FastEscape
        autocmd!
        autocmd InsertEnter * set timeoutlen=0
        autocmd InsertLeave * set timeoutlen=1000
    augroup END
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" End Powerline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

" ~/.vimrc ends here
