"
" Author: Ash<tuxdude.github@gmail.com>
"

" RPM related stuff

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
