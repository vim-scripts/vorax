" Description: Overwrite settings for plsql file type
" Mainainder: Alexandru Tica <alexandru.tica.at.gmail.com>
" License: Apache License 2.0

" switch to vorax completion
setlocal omnifunc=Vorax_Complete

" defines vorax mappings for the current buffer
" defines vorax mappings for the current buffer
if !exists('*Vorax_UtilsToolkit')
  runtime! vorax/lib/vim/vorax_utils.vim
endif

let utils = Vorax_UtilsToolkit()
call utils.CreateBufferMappings()

" we don't have indenting for plsql therefore indent 
" like an sql file please
exec 'runtime indent/sql.vim'

" tag plsql files as sqls
if exists('loaded_taglist')
  let tlist_plsql_settings='sql;c:cursor;F:field;P:package;r:record;' .
        \ 's:subtype;t:table;T:trigger;v:variable;f:function;p:procedure'
endif

" take $# as word characters
setlocal isk+=$
setlocal isk+=#

" matchit functionality (taken from the standard sql.vim ftplugin)
" Some standard expressions for use with the matchit strings
let s:notend = '\%(\<end\s\+\)\@<!'
let s:when_no_matched_or_others = '\%(\<when\>\%(\s\+\%(\%(\<not\>\s\+\)\?<matched\>\)\|\<others\>\)\@!\)'
let s:or_replace = '\%(or\s\+replace\s\+\)\?'

" Define patterns for the matchit macro
if !exists("b:match_words")
    " SQL is generally case insensitive
    let b:match_ignorecase = 1

    " Handle the following:
    " if
    " elseif | elsif
    " else [if]
    " end if
    "
    " [while condition] loop
    "     leave
    "     break
    "     continue
    "     exit
    " end loop
    "
    " for
    "     leave
    "     break
    "     continue
    "     exit
    " end loop
    "
    " do
    "     statements
    " doend
    "
    " case
    " when 
    " when
    " default
    " end case
    "
    " merge
    " when not matched
    " when matched
    "
    " EXCEPTION
    " WHEN column_not_found THEN
    " WHEN OTHERS THEN
    "
    " create[ or replace] procedure|function|event

    let b:match_words =
		\ '\<begin\>:\<end\>\W*$,'.
		\
                \ s:notend . '\<if\>:'.
                \ '\<elsif\>\|\<elseif\>\|\<else\>:'.
                \ '\<end\s\+if\>,'.
                \
                \ '\<do\>\|'.
                \ '\<while\>\|'.
                \ '\%(' . s:notend . '\<loop\>\)\|'.
                \ '\%(' . s:notend . '\<for\>\):'.
                \ '\<exit\>\|\<leave\>\|\<break\>\|\<continue\>:'.
                \ '\%(\<end\s\+\%(for\|loop\>\)\)\|\<doend\>,'.
                \
                \ '\%('. s:notend . '\<case\>\):'.
                \ '\%('.s:when_no_matched_or_others.'\):'.
                \ '\%(\<when\s\+others\>\|\<end\s\+case\>\),' .
                \
                \ '\<merge\>:' .
                \ '\<when\s\+not\s\+matched\>:' .
                \ '\<when\s\+matched\>,' .
                \
                \ '\%(\<create\s\+' . s:or_replace . '\)\?'.
                \ '\%(function\|procedure\|event\):'.
                \ '\<returns\?\>'
                " \ '\<begin\>\|\<returns\?\>:'.
                " \ '\<end\>\(;\)\?\s*$'
                " \ '\<exception\>:'.s:when_no_matched_or_others.
                " \ ':\<when\s\+others\>,'.
		"
                " \ '\%(\<exception\>\|\%('. s:notend . '\<case\>\)\):'.
                " \ '\%(\<default\>\|'.s:when_no_matched_or_others.'\):'.
                " \ '\%(\%(\<when\s\+others\>\)\|\<end\s\+case\>\),' .
endif

