"
"" Author: Ash<tuxdude.github@gmail.com>
"

" Detect if it is a valid Perforce Spec
function! s:P4SpecFtSetup()
    if getline(1) =~ '^# A Perforce \(.*\) Specification.$'
        set ft=perforce
    endif
endfunction

augroup P4SpecAsPerforce
    autocmd!
    autocmd BufRead,BufNewFile * call s:P4SpecFtSetup()
augroup END
