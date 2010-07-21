" Description: Overwrite settings for plsql file type
" Mainainder: Alexandru Tica <alexandru.tica.at.gmail.com>
" License: Apache License 2.0

" switch to vorax completion
setlocal omnifunc=Vorax_Complete

" defines vorax mappings for the current buffer
call vorax#CreateBufferMappings()

" we don't have indenting for plsql therefore indent 
" like an sql file please
exec 'runtime indent/sql.vim'

