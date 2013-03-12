"
" Author: Ash<tuxdude.github@gmail.com>
"

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
autocmd BufNewFile *.spec call SKEL_spec()
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
set hls!

" Taglist plugin
let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>

" Rebuild tags
map <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" Enable doxygen for c, cpp and idl files
let g:load_doxygen_syntax=1
let g:doxygen_enhanced_color=1

" Force .inc files as Makefile syntax highlighting
au BufReadPost *.inc set syntax=make

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

" Load powerline bindings
set rtp+=~/.local/lib/python2.7/site-packages/powerline/bindings/vim

" To make the powerline status line show up in non-split windows
set laststatus=2

" ~/.vimrc ends here
