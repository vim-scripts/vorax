" Description: Overwrite settings for sql file type
" Mainainder: Alexandru Tica <alexandru.tica.at.gmail.com>
" License: Apache License 2.0

" switch to vorax completion
setlocal omnifunc=Vorax_Complete

" defines vorax mappings for the current buffer
if mapcheck('<Leader>ve', 'n') == ""
    nmap <buffer> <unique> <Leader>ve :VoraxExecUnderCursor<cr>
endif

if mapcheck('<Leader>ve', 'v') == ""
    xmap <buffer> <unique> <Leader>ve :VoraxExecVisualSQL<cr>
endif

if mapcheck('<Leader>vb', 'n') == ""
    nmap <buffer> <unique> <Leader>vb :VoraxExecBuffer<cr>
endif

if mapcheck('<Leader>vd', 'n') == ""
    nmap <buffer> <unique> <Leader>vd :VoraxDescribe<cr>
endif

