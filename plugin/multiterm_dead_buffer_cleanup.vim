" Multiterm dead-buffer cleanup:
" wipe a dead Multiterm terminal buffer once its window is no longer visible.

if exists('g:loaded_multiterm_dead_buffer_cleanup') || !exists(':terminal')
    finish
endif
let g:loaded_multiterm_dead_buffer_cleanup = 1

function! s:has_multiterm_marker(bufnr) abort
    for name in ['multiterm_tag', 'multiterm#tag', 'multiterm', 'term_tag', 'tag']
        if getbufvar(a:bufnr, name) != -1
            return 1
        endif
    endfor
    return 0
endfunction

function! s:is_multiterm_buffer(bufnr) abort
    if !bufexists(a:bufnr)
        return 0
    endif
    if getbufvar(a:bufnr, '&buftype') !=# 'terminal'
        return 0
    endif
    if s:has_multiterm_marker(a:bufnr)
        return 1
    endif
    " Multiterm floating terminal buffers are normally not listed.
    return getbufvar(a:bufnr, '&buflisted') == 0
endfunction

function! s:can_wipe_dead_buffer(bufnr) abort
    if !s:is_multiterm_buffer(a:bufnr)
        return 0
    endif
    if bufwinid(a:bufnr) != -1
        return 0
    endif
    return 1
endfunction

function! s:wipe_dead_buffer(bufnr) abort
    if s:can_wipe_dead_buffer(a:bufnr)
        silent! bwipeout! a:bufnr
    endif
endfunction

function! s:on_term_closed(bufnr) abort
    let l:bufnr = a:bufnr
    if !s:is_multiterm_buffer(l:bufnr)
        return
    endif
    call timer_start(100, {-> s:wipe_dead_buffer(l:bufnr)})
endfunction

augroup MultitermDeadBufferCleanup
    autocmd!
    autocmd TermClosed * call s:on_term_closed(expand('<abuf>'))
augroup END
