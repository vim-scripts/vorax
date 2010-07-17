" VoraX:      an oracle IDE under vim
" Author:     Alexandru Tică
" Date:	      15/04/10 14:08:20  
" Version:    1.0
" Copyright:  Copyright (C) 2010 Alexandru Tică
"             Apache License, Version 2.0
"             http://www.apache.org/licenses/LICENSE-2.0.html

if exists("g:loaded_vorax") || &cp
  finish
endif

if v:version < 700
  echohl WarningMsg
  echo "***warning*** this version of VoraX needs vim 7.0"
  echohl Normal
  finish
endif

let g:loaded_vorax = "1.3"
let s:keep_cpo = &cpo
set cpo&vim

"""""""""""""""""""""""""""""""""""
" Configuration section
"""""""""""""""""""""""""""""""""""
if !exists('g:vorax_sqlplus_header')
  " a lf delimited list of commands to be executed into the sqlplus
  " envirnoment before creating a new oracle session. These commands do not overide the
  " settings from the [g]login.sql file.
  let g:vorax_sqlplus_header = "set linesize 10000\n" .
                             \ "set tab off\n" .
                             \ "set wrap off\n" .
                             \ "set ver off\n" .
                             \ "set flush on\n" .
                             \ "set colsep \"   \"\n" .
                             \ "set trimout on\n" .
                             \ "set trimspool on\n"
endif

if !exists('g:vorax_resultwin_geometry')
  " The geometry of the result window. 
  " The syntax is the same as for split
  let g:vorax_resultwin_geometry = "botright 20"
endif

if !exists('g:vorax_resultwin_clear')
  " Defines whenever or not the result window to be
  " cleared between subsequent SQL executions
  let g:vorax_resultwin_clear = 1
endif

if !exists('g:vorax_inline_prompt')
  " Defines whenever or not the result window to be
  " used for asking the user for various values
  " (e.g. ACCEPT commands). If this flag is not set
  " VoraX will prompt for values in the command line.
  let g:vorax_inline_prompt = 1
endif

if !exists('g:vorax_dbexplorer_side')
  " Defines where to anchor the dbexplorer: 1 means at
  " the right, 0 means to the left
  let g:vorax_dbexplorer_side = 1
endif

if !exists('g:vorax_dbexplorer_width')
  " Configures the width of the db explorer window
  let g:vorax_dbexplorer_width = 30
endif

if !exists('g:vorax_dbexplorer_object_over_file')
  " Configures how dbexplorer should open an object from
  " the database when a file with the same name is in the
  " current directory. The possible values are:
  "   0 = always load the source from the database
  "   1 = always load the file if there is one
  "   2 = ask the user
  let g:vorax_dbexplorer_object_over_file = 2
endif

if !exists('g:vorax_dbexplorer_file_extensions')
  " Configures the file extension for every database
  " object type. If a type is not here then the .sql
  " extension will be used.
  let g:vorax_dbexplorer_file_extensions = [  
                                        \     {'type' : 'PACKAGE', 'ext' : 'pkg'} ,
                                        \     {'type' : 'PACKAGE_SPEC', 'ext' : 'spc'} ,
                                        \     {'type' : 'PACKAGE_BODY', 'ext' : 'bdy'} ,
                                        \     {'type' : 'FUNCTION', 'ext' : 'fnc'} ,
                                        \     {'type' : 'TYPE', 'ext' : 'typ'} ,
                                        \     {'type' : 'TYPE_SPEC', 'ext' : 'tps'} ,
                                        \     {'type' : 'TYPE_BODY', 'ext' : 'tpb'} ,
                                        \     {'type' : 'TABLE', 'ext' : 'tab'} ,
                                        \     {'type' : 'VIEW', 'ext' : 'viw'} ,
                                        \  ]
endif

" A sort of messages resource for VoraX.
if !exists('g:vorax_messages')
  let g:vorax_messages = { 
                        \  "done"                             : "done.",
                        \  "executing"                        : "Executing...",
                        \  "how_to_prompt"                    : "press ENTER to answer for prompted values.",
                        \  "username"                         : "Username",
                        \  "password"                         : "Password",
                        \  "database"                         : "Database",
                        \  "prompt_on_last_line_only"         : "User input is accepted on the last line only.",
                        \  "cancel_confirmation"              : "Are you sure you want to cancel the execution of this statement?",
                        \  "abort_session"                    : "The session was cancelled but the connection was lost. Reconnect to {#}?",
                        \  "still_executing"                  : "You cannot run a statement while another one is still executing!",
                        \  "unexpected_error"                 : "An error has occured... please check the logs.",
                        \  "not_connected"                    : "Not connected to Oracle!",
                        \  "wrong_buffer"                     : "Cannot execute this type of buffer!",
                        \  "dbexpl_edit_file_confirmation"    : "There is a [{#}] file in the current directory. If you just want to load " .
                        \                                       "the source for the database press ENTER, otherwise enter {#} to edit: " ,
                        \}
endif

if !exists('g:vorax_debug')
  " Wherever or not to write into a log file. This
  " feature relies to the existance of the log.vim
  " plugin: http://www.vim.org/scripts/script.php?script_id=2330
  " The log plugin should reside in autoload directory.
  let g:vorax_debug = 0
endif

"""""""""""""""""""""""""""""""""""
" Define commands
"""""""""""""""""""""""""""""""""""
if !exists(':VoraxConnect')
    command! -nargs=? VoraxConnect :call vorax#Connect(<q-args>)
    nmap <unique> <script> <Plug>VoraxConnect :VoraxConnect<CR>
endif

if !exists(':VoraxExecUnderCursor')
    command! -nargs=0 VoraxExecUnderCursor :call vorax#Exec('', 1)
    nmap <unique> <script> <Plug>VoraxExecUnderCursor :VoraxExecUnderCursor<CR>
endif

if !exists(':VoraxExecBuffer')
    command! -nargs=0 VoraxExecBuffer :call vorax#ExecBuffer()
    nmap <unique> <script> <Plug>VoraxExecBuffer :VoraxExecBuffer<CR>
endif

if !exists(':VoraxDbExplorer')
    command! -nargs=0 VoraxDbExplorer :call vorax#DbExplorer()
    nmap <unique> <script> <Plug>VoraxDbExplorer :VoraxDbExplorer<CR>
endif

if !exists(':VoraxExecVisualSQL')
    command! -nargs=0 -range VoraxExecVisualSQL :call vorax#Exec(vorax#SelectedBlock(), 1)
    xmap <unique> <script> <Plug>VoraxExecVisualSQL :VoraxExecVisualSQL<CR>
endif

if !exists(':VoraxDescribe')
    command! -nargs=? VoraxDescribe :call vorax#Describe(<q-args>)
    nmap <unique> <script> <Plug>VoraxDescribe :VoraxDescribe<CR>
endif

"""""""""""""""""""""""""""""""""""
" Define mappings
"""""""""""""""""""""""""""""""""""
if !hasmapto('<Plug>VoraxExecVisualSQL') && !hasmapto('<Leader>ve', 'v')
    xmap <unique> <Leader>ve <Plug>VoraxExecVisualSQL
endif

if !hasmapto('<Plug>VoraxExecUnderCursor') && !hasmapto('<Leader>ve', 'n')
    nmap <unique> <Leader>ve <Plug>VoraxExecUnderCursor
endif

if !hasmapto('<Plug>VoraxExecBuffer') && !hasmapto('<Leader>vb', 'n')
    nmap <unique> <Leader>vb <Plug>VoraxExecBuffer
endif

if !hasmapto('<Plug>VoraxConnect') && !hasmapto('<Leader>vc', 'n')
    nmap <unique> <Leader>vc <Plug>VoraxConnect
endif

if !hasmapto('<Plug>VoraxDbExplorer') && !hasmapto('<Leader>vv', 'n')
    nmap <unique> <Leader>vv <Plug>VoraxDbExplorer
endif

if !hasmapto('<Plug>VoraxDescribe') && !hasmapto('<Leader>vd', 'n')
    nmap <unique> <Leader>vd <Plug>VoraxDescribe
endif

"""""""""""""""""""""""""""""""""""
" Define autocmds
"""""""""""""""""""""""""""""""""""
augroup VoraX
  " Analyze the file and set as a VoraX buffer
  au BufNewFile,BufRead * call vorax#InitBuffer()
augroup END

"""""""""""""""""""""""""""""""""""
" Internal stuff
"""""""""""""""""""""""""""""""""""
let s:interface = {}

"""""""""""""""""""""""""""""""""""
" Public API
"""""""""""""""""""""""""""""""""""

" Registers a plaform interface. The idea is that VoraX cannot operate
" in a platform independent way without specific code for that particular
" platform. That code may be wrapped in a different vim script placed under
" vorax/interface location which will be sourced at the time the VoraX
" plugin is loaded. Is up to the interface code to check the actual
" platform using the has(<feature>) function. The [a:interface] parameter
" expected by this function should be an object (dictionary) having a
" well known structure. For additional details please see the existing
" interfaces under vorax/interface location.
function Vorax_RegisterInterface(interface)
  let s:interface = copy(a:interface)
endfunction

" Get the current vorax interface.
function Vorax_GetInterface()
  return s:interface
endfunction

" Load interfaces
runtime! vorax/interface/**/*.vim

" Load vim libraries
runtime! vorax/lib/vim/*.vim

" Load ruby libraries
let s:ruby_lib_dir = fnamemodify(finddir('vorax/lib/ruby', fnamemodify(&rtp, ':p:8')), ':p:8')
let s:ruby_lib_dir = substitute(s:ruby_lib_dir, '\', '/', 'g')
" the above trickery is for Windows OS
if s:ruby_lib_dir != ""
  let s:ruby_lib_dir = substitute(s:ruby_lib_dir, '\', '/', 'g')
  ruby require "rubygems"
  ruby Dir[VIM::evaluate('s:ruby_lib_dir')+"*.rb"].each {|file| require file}
endif

let &cpo = s:keep_cpo
unlet s:keep_cpo

