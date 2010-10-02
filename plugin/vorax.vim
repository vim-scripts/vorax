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

let g:loaded_vorax = "2.4"
let s:keep_cpo = &cpo
set cpo&vim

"""""""""""""""""""""""""""""""""""
" Configuration section
"""""""""""""""""""""""""""""""""""
if !exists('g:vorax_sqlplus_header')
  " a cr delimited list of commands to be executed into the sqlplus
  " envirnoment before creating a new oracle session. These commands do not overide the
  " settings from the [g]login.sql file. If you want echoing for your commands then
  " add [set echo on\n] at the end of this header.
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
                                        \     {'type' : 'PROCEDURE', 'ext' : 'prc'} ,
                                        \     {'type' : 'TRIGGER', 'ext' : 'trg'} ,
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
                        \  "start_log"                        : "Logging started into {#}",
                        \  "error_log"                        : "Cannot start logging!\n{#}",
                        \  "stop_log"                         : "Logging stopped!",
                        \  "connecting"                       : "Connecting to {#}...",
                        \  "load_wait"                        : "Loading {#}. Please wait...",
                        \  "reading"                          : "Reading...",
                        \  "open_obj"                         : "Opening {#}...",
                        \  "search_for"                       : "Search for {#}...",
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
                        \  "wrong_file"                       : "Vorax cannot execute this type of file!",
                        \  "dir_not_allowed"                  : "Vorax cannot execute a directory.",
                        \  "dbexpl_edit_file_confirmation"    : "There is a [{#}] file in the current directory. If you just want to load " .
                        \                                       "the source for the database press ENTER, otherwise enter {#} to edit: " ,
                        \  "invalid_password"                 : "Invalid password or key files.",
                        \  "master_password"                  : "Master password",
                        \  "store_passwd_question"            : "Would you like to store the password for this connection profile?",
                        \  "passwd_mismatch"                  : "Passwords do not match! Retry please...",
                        \  "retype_master_passwd"             : "Retype the master password",
                        \  "master_passwd_required"           : "A master password is required",
                        \  "passwd_repo_not_ready"            : "A repository with passwords was not initialized yet. VoraX will create one now...",
                        \  "passwd_retry_exceeded"            : "Too many password retries. Give up...",
                        \  "invalid_desc"                     : "Cannot describe this object.",
                        \  "no_prev_stmt"                     : "No previous statement to execute.",
                        \  "vorax_fuzzy_prompt"               : "VoraX Search: ",
                        \  "fuzzy_build"                      : "Please wait... Building dictionary for: ",
                        \  "no_help"                          : "Sorry! No help for this.",
                        \  "help_search_error"                : "Error in search!",
                        \  "no_pattern"                       : "No pattern provided.",
                        \  "oradoc_prompt"                    : "OraDoc Search: ",
                        \}
endif

if !exists('g:vorax_logging')
  " whenever or not to log everything is written into the
  " result window.
  let g:vorax_logging = 0
endif

if !exists('g:vorax_logging_dir')
  " where to write the log file
  let g:vorax_logging_dir = expand('$HOME') 
endif

if !exists('g:vorax_connwin_geometry')
  " The geometry of the connection window. 
  " The syntax is the same as for split
  let g:vorax_connwin_geometry = "vertical botright 25"
endif

if !exists('g:vorax_open_scratch_at_connect')
  " whenever or not a scratch sql buffer to be opened at
  " connect time.
  let g:vorax_open_scratch_at_connect = 1
endif

if !exists('g:vorax_store_passwords')
  " whenever or not VoraX should automatically store Oracle
  " passwords in a safe way.
  let g:vorax_store_passwords = 0
endif

if !exists('g:vorax_min_fuzzy_chars')
  " the minimum number of characters the user should type in
  " order to fetch the list of searchable objects from the
  " database. Please don't set this variable to a value
  " lower than 3.
  let g:vorax_min_fuzzy_chars = 3
endif

if !exists('g:vorax_oradoc_geometry')
  " The geometry for the oradoc window. 
  " The syntax is the same as for split
  let g:vorax_oradoc_geometry = "botright 10"
endif

if !exists('g:vorax_oradoc_index_file')
  " The location for the documentation index.
  let g:vorax_oradoc_index_file = substitute(fnamemodify(expand('$HOME'), ':p:8') . '/vorax_oradoc.idx', '\\', '/', 'g')
endif

if !exists('g:vorax_oradoc_config_file')
  " The swish-e config file.
  let g:vorax_oradoc_config_file = substitute(fnamemodify(finddir('vorax/oradoc/conf', fnamemodify(&rtp, ':p:8')) . '/vorax_oradoc.conf', ':p:8'), '\', '/', 'g')
endif

if !exists('g:vorax_oradoc_autoclose')
  " Wherever or not the oradoc window to be automatically closed
  " after opening a doclink
  let g:vorax_oradoc_autoclose = 0
endif

if !exists('g:vorax_oradoc_open_with')
  " The browser to be used when openning a documentation link. The
  " placeholder for link is %u
  if has('win32')
    let g:vorax_oradoc_open_with = 'silent! !start C:\Program Files\Internet Explorer\iexplore.exe %u'
  elseif has('unix')
    " asume firefox executable is in your $PATH
    let g:vorax_oradoc_open_with = "silent! !firefox -remote 'ping()' && firefox -remote 'openURL( %u )' || firefox '%u' &"
  endif
endif

if !exists('g:vorax_debug')
  " Whenever or not to write into a log file. This
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

if !exists(':VoraxHelp')
    command! -nargs=? VoraxHelp :call vorax#OradocSearch(<q-args>)
    nmap <unique> <script> <Plug>VoraxHelp :VoraxHelp<CR>
endif

if !exists(':VoraxHelpBuildIndex')
    command! -nargs=? -complete=file VoraxHelpBuildIndex :call vorax#OradocBuild(<q-args>)
    nmap <unique> <script> <Plug>VoraxHelpBuildIndex :VoraxHelpBuildIndex<CR>
endif

if !exists(':VoraxExecUnderCursor')
    command! -nargs=0 VoraxExecUnderCursor :call vorax#Exec('', 1, "")
endif

if !exists(':VoraxExplainUnderCursor')
    command! -nargs=0 VoraxExplainUnderCursor :call vorax#Explain('', 0)
endif

if !exists(':VoraxExplainOnlyUnderCursor')
    command! -nargs=0 VoraxExplainOnlyUnderCursor :call vorax#Explain('', 1)
endif

if !exists(':VoraxExecBuffer')
    command! -nargs=0 VoraxExecBuffer :call vorax#ExecBuffer()
endif

if !exists(':VoraxDbExplorer')
    command! -nargs=0 VoraxDbExplorer :call vorax#DbExplorer()
    nmap <unique> <script> <Plug>VoraxDbExplorer :VoraxDbExplorer<CR>
endif

if !exists(':VoraxExecVisualSQL')
    command! -nargs=0 -range VoraxExecVisualSQL :call vorax#Exec(vorax#SelectedBlock(), 1, "")
endif

if !exists(':VoraxExplainVisualSQL')
    command! -nargs=0 -range VoraxExplainVisualSQL :call vorax#Explain(vorax#SelectedBlock(), 0)
endif

if !exists(':VoraxExplainOnlyVisualSQL')
    command! -nargs=0 -range VoraxExplainOnlyVisualSQL :call vorax#Explain(vorax#SelectedBlock(), 1)
endif

if exists(':VoraxDescribeVisual') != 2
    command! -nargs=0 -range VoraxDescribeVisual :call vorax#Describe(vorax#SelectedBlock())
endif

if exists(':VoraxDescribe') != 2
    command! -nargs=? VoraxDescribe :call vorax#Describe(<q-args>)
endif

if exists(':VoraxDescribeVerboseVisual') != 2
    command! -nargs=0 -range VoraxDescribeVerboseVisual :call vorax#DescribeVerbose(vorax#SelectedBlock())
endif

if exists(':VoraxDescribeVerbose') != 2
    command! -nargs=? VoraxDescribeVerbose :call vorax#DescribeVerbose(<q-args>)
endif

if !exists(':VoraxGotoDefinition')
    command! -nargs=? VoraxGotoDefinition :call vorax#GotoDefinition(<q-args>)
endif

if !exists(':VoraxToggleConnWindow')
    command! -nargs=0 VoraxToggleConnWindow :call vorax#ToggleConnWindow()
    nmap <unique> <script> <Plug>VoraxToggleConnWindow :VoraxToggleConnWindow<CR>
endif

if !exists(':VoraxSearch')
    command! -nargs=0 VoraxSearch :call vorax#Search()
endif
"""""""""""""""""""""""""""""""""""
" Define mappings
"""""""""""""""""""""""""""""""""""
if !hasmapto('<Plug>VoraxConnect') && !hasmapto('<Leader>vc', 'n')
    nmap <unique> <Leader>vc <Plug>VoraxConnect
endif

if !hasmapto('<Plug>VoraxHelp') && !hasmapto('<Leader>vh', 'n')
    nmap <unique> <Leader>vh <Plug>VoraxHelp
endif

if !hasmapto('<Plug>VoraxDbExplorer') && !hasmapto('<Leader>vv', 'n')
    nmap <unique> <Leader>vv <Plug>VoraxDbExplorer
endif

if !hasmapto('<Plug>VoraxToggleConnWindow') && !hasmapto('<Leader>vo', 'n')
    nmap <unique> <Leader>vo <Plug>VoraxToggleConnWindow
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

let s:event_handler = {}

" this function is used to register keys for the result window
function s:event_handler.rwin_register_keys() dict
endfunction

" this function is used to register keys for sql/plsql buffers
function s:event_handler.buf_register_keys() dict
endfunction

" this function is used to register keys for db explorer
function s:event_handler.dbexplorer_register_keys() dict
endfunction

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

" Get the current event handler
function Vorax_GetEventHandler()
  return s:event_handler
endfunction

" Get the current vorax interface.
function Vorax_GetInterface()
  return s:interface
endfunction

let &cpo = s:keep_cpo
unlet s:keep_cpo

