" Description: Autoload buddy script for VoraX.
" Mainainder: Alexandru Tica <alexandru.tica.at.gmail.com>
" License: Apache License 2.0

" no multiple loads allowed
if exists("g:autoload_vorax")
  finish
endif

" flag to signal this source was loaded
let g:autoload_vorax = 1

" The name of the vorax results buffer
let s:vorax_result_bufname = "vorax-results"

" The interface object
let s:interface = Vorax_GetInterface()

" Stores the current credentials
let s:cdata = {}

" This variable is used internally when results from the
" interface are put back together
let s:last_truncated = 1

" This variable is used internally to determine the
" user input within the results window
let s:last_line = ""

" This variable isused internally to determine when
" the connection was changed
let s:last_db_explorer_connection = "@"

" This variable contains all plsql_objects processed by the
" last exec command in foreground mode. This is used to
" display errors on compilation.
let s:processed_plsql_objects = []

" This variable contains the buffer number from where the
" last fg exec command was executed.
let s:exec_from_buffer = bufnr('%')

" A flag which indicates whenever or not the user is
" connected
let s:connected = 0

" The title of the vorax db explorer
let s:db_explorer_title = 'Vorax-DbExplorer'

" A temporary file to save to/restore from sqlplus settings
let s:temp_settings_file = fnamemodify(tempname(), ':p:h') . '/vrx_settings.sql'

" Enable logging
if g:vorax_debug
  silent! call log#init('ALL', ['~/vorax.log'])
  silent! let s:log = log#getLogger(expand('<sfile>:t'))
endif

" This function is used to parse a connect string. It receives
" a string like 'user/pwd@db' and it breaks it down into the
" corresponding user,pwd,db parts. It returns these components
" into a dictionary structure: 
"   {'user': , 'passwd': , 'db': , 'osauth': }
" The osauth flag is set if the provided connection string is 
" requesting an OS authentication (e.g. / as sysdba).
function! s:ParseCstr(cstr) 
  " parse the connect string
  let conn_str = a:cstr
  let cdata = {'user': '', 'passwd': '', 'db': '', 'osauth' : 0}
  " find the position of the first unquoted @
  let arond_pos = match(conn_str, '@\([^\"]*"\([^"]\|"[^"]*"\)*$\)\@!', 1, 1)
  " find the position of the first unquoted /
  let slash_pos = match(conn_str, '\/\([^\"]*"\([^"]\|"[^"]*"\)*$\)\@!', 1, 1)
  if arond_pos >= 0
    " we have the database specified
    let cdata['db'] = strpart(conn_str, arond_pos + 1, strlen(conn_str))
    let conn_str = strpart(conn_str, 0, arond_pos)
  endif
  if slash_pos >= 0
    " we have the username and the password specified
    let cdata['user'] = strpart(conn_str, 0, slash_pos)
    let cdata['passwd'] = strpart(conn_str, slash_pos + 1, strlen(conn_str))
  else
    " if no slash then everything before @ is asumed to be the user
    let cdata['user'] = conn_str
  endif
  " trim leading/trailing spaces from cdata
  for key in keys(cdata)
    let cdata[key] = substitute(cdata[key],'^\s\+\|\s\+$',"","g")
  endfor
  " check for OS auth
  if cdata['db'] =~? '^\s*as\s*(sysdba|sysasm|sysoper)\s*$'
    let cdata['osauth'] = 1
  endif
  return cdata
endfunction

" Prompt the user for the credentials. It requests only the missing parts
" therefore if you already provided something like user@db then just
" the password will be requested.
function! s:PromptCredentials(cstr)
  let cdata = s:ParseCstr(a:cstr)
  if cdata['user'] == ''
    " prompt for user
    let user = input(g:vorax_messages['username'] . ': ')
    if (cdata['passwd'] == '') || (cdata['db'] == '')
      " reparse the new provided string
      let ncd = s:ParseCstr(user)
      let cdata['user'] = ncd['user']
      if ncd['passwd'] != ''
        let cdata['passwd'] = ncd['passwd']
      endif
      if ncd['db'] != ''
        let cdata['db'] = ncd['db']
      endif
    endif
  endif
  if cdata['passwd'] == ''
    let cdata['passwd'] = inputsecret(g:vorax_messages['password'] . ': ')
  endif
  if cdata['db'] == ''
    let cdata['db'] = input(g:vorax_messages['database'] . ': ')
  endif
  return cdata
endfunction

" print the provided error
function! s:EchoErr(msg)
  echohl WarningMsg
  echo a:msg
  echohl Normal
endfunction

" Get the end delimitator. This function tries to guess the
" type of the delimitator according to the given statement. If
" a plsql block is given then a slash is returned otherwise, if
" no ';' is detected then ';' is returned.
function! s:Delimitator(cmd)
  if a:cmd =~ '\v\n+\s*/\s*\n*$'
    " if an ending slash is found then no delimitator is required
    return ''
  endif
  if a:cmd =~ '\vend\_s*"?[a-z0-9_$#]*"?\_s*;\_s*\_$'
    " a plsql block was given
    return "\n/\n"
  elseif a:cmd !~ '\v\_s*;\_s*\_$'
    " a regular sqlplus command. Pay attention that no \n is
    " added in order to cover the sqlplus special commands too.
    " For example, if the command is 'set lines 200' we detect
    " that there's no terminator therefore we add one, but on
    " the same line. It would be wrong in this case to add this
    " terminator on a new line.
    return ';'
  else
    return ''
  endif
endfunction

" Displays the results window. This function is smart enough to
" figure out wherever or not this window has to be created or
" just focused.
function! s:FocusResultsWindow()
  let result_buf_nr = bufnr('^' . s:vorax_result_bufname . '$')
  silent! call s:log.debug('result_buf_nr='.result_buf_nr)
  if result_buf_nr == -1
    " the result buffer was closed, create a new one
    silent! exec g:vorax_resultwin_geometry . ' new'
    silent! exec "edit " .s:vorax_result_bufname
  else
    " is the buffer visible?
    let result_win_nr = bufwinnr(result_buf_nr)
    if result_win_nr == -1
      " it is not visible
      silent! exec g:vorax_resultwin_geometry . 'split'
      silent! exec "edit " .s:vorax_result_bufname
    else
      exec result_win_nr . "wincmd w"
    endif
  endif
endfunction

" Usually called after executing something and
" the results has to be displayed. Basically, this function
" opens/focuses the results window and register the monitor
" which will further populate it.
function! s:ShowResults()
  silent! call s:log.trace('start of s:ShowResults')
  call s:FocusResultsWindow()
  " clear the result window?
  if g:vorax_resultwin_clear
    normal ggdG
  endif
  normal G$
  setlocal updatetime=50
  setlocal winfixwidth
  setlocal noswapfile
  setlocal buftype=nofile
  setlocal nowrap
  setlocal foldcolumn=0
  setlocal nobuflisted
  setlocal nospell
  setlocal nonu
  setlocal cursorline
  " highlight errors
  match ErrorMsg /^\(ORA-\|SP-\).*/
  redraw
  if g:vorax_inline_prompt
    echo g:vorax_messages['executing']
  else
    echo g:vorax_messages['executing'] . ' ' .g:vorax_messages['how_to_prompt']
  endif
  call s:StartMonitor()
  silent! call s:log.trace('end of s:ShowResults')
endfunction

" This function is used to get input from the user. Most
" of the time is about sqlplus ACCEPT like commands. Determining
" the user input is quite picky because in vim there's no efficient
" way of finding what was changed in a buffer therefore this function 
" simply assumes that the inputed text is whatever follows the text from the
" last line before entering in insert mode.
function! vorax#processUserInput()
  " process user input only if a statement is currently
  " executing.
  if s:interface.more
    let input = ""
    if g:vorax_inline_prompt
      " accept input just on the last line
      if line('.') == line('$')
        let line = getline('$')
        let input = strpart(line, len(s:last_line))
        call append(line('$'), "")
      else
        call s:EchoErr(g:vorax_messages['prompt_on_last_line_only'])
        " go to the last line
        stopinsert
        normal UG$
        " enter in insert mode just after the prompt is
        startinsert!
        return
      endif
    else
      let line = getline('$')
      let input = input(line == "" ? "?: " : line)
      call setline(line('$'), line . input)
      call append(line('$'), "")
    endif
    call s:interface.send(input)
  endif
endfunction

" Cancel the currently executing statement
function! vorax#cancelExec()
  let response = input(g:vorax_messages['cancel_confirmation'] . " (y/[N]): ")
  if response =~? '\s*y\s*'
    if s:interface.more && !s:interface.cancel()
      " if cancel operation from the interface tells that it's not safe to continue
      " with the current session, inform the user and ask him/her for a new connection
      let response = input(vorax#translate(g:vorax_messages['abort_session'],  
                        \ s:cdata['user'] . '@' . s:cdata['db']) . " ([y]/n): ")
      if response =~? '\s*y\?\s*'
        " build up a connection string from the last credentials
        let cs = s:cdata['user'] . '/"' . s:cdata['passwd'] . '"'
        if s:cdata['osauth'] 
          let cs .= " " . s:cdata['db']
        else
          let cs .= "@". s:cdata['db']
        endif
        " it doesn't make sense to continue monitoring
        call s:StopMonitor()
        " initiate a new connection
        call vorax#Connect(cs)
      endif
    endif
  endif
endfunction

" Starts the monitor for the results window.
function! s:StartMonitor()
  call s:FocusResultsWindow()
  if g:vorax_inline_prompt
    imap <buffer> <cr> <esc>:call vorax#processUserInput()<cr>
  else
    nmap <buffer> <cr> :call vorax#processUserInput()<cr>
  endif
  nmap <buffer> <c-c> :call vorax#cancelExec()<cr>
  au VoraX CursorHold <buffer> call vorax#fetchResults()
  call feedkeys("f\e")  
endfunction

" Stop the monitor for the results window.
function! s:StopMonitor()
  call s:FocusResultsWindow()
  mapclear <buffer>
  imapclear <buffer>
  au VoraX CursorHold <buffer> call vorax#fetchResults()
  autocmd! VoraX CursorHold <buffer>
endfunction

function! s:BusyIndicator()
  if !exists('s:vorax_status') || s:vorax_status == "|"
    let s:vorax_status = '/'
  elseif s:vorax_status == '/'
    let s:vorax_status = '-'
  elseif s:vorax_status == '-'
    let s:vorax_status = '\'
  elseif s:vorax_status == '\'
    let s:vorax_status = '|'
  endif
  return s:vorax_status
endfunction

" Rebuild the Vorax DB Explorer. This is needed especially
" after the connection was changed.
function s:RebuildDbExplorer()
  let ts = VrxTree_GetSettings(s:db_explorer_title)
  if has_key(ts, 'root') && ts['root'] != &titlestring
    " is the dbexplorer visible?
    let bnr = bufnr(s:db_explorer_title)
    if bnr != -1  
      " the buffer exists. is in a visible window?
      let wnr = bufwinnr(bnr) 
      if wnr != -1
        " the window is visible... focus it
        exec bnr . "bw"
        call vorax#DbExplorer()
      endif
    endif
  endif
endfunction

" This function is called by the monitor (aka CursorHold autocmd)
" which incrementally fills in the results window.
function! vorax#fetchResults()
  let result = s:interface.read() 
  if len(result) > 0
    if s:last_truncated
      " if the previous line was truncated, just merge it
      " with the current one
      let s:last_line = getline('$') .result[0]
      call setline(line('$'), s:last_line)
      call remove(result, 0)
    endif
    if len(result) > 0
      call append(line('$'), result)
      let s:last_line = result[-1]
    endif
    let s:last_truncated = s:interface.truncated
    normal G
  endif
  " show progress informationn... a redraw is needed
  redraw
  echon g:vorax_messages['executing'] . (g:vorax_inline_prompt ? " " : " " . g:vorax_messages['how_to_prompt']) . " " . s:BusyIndicator()
  if (!s:interface.more)
    " no more data from the interface... it's safe to stop monitoring
    call s:StopMonitor()
    " maybe a connect statement was issued which means the connected user@db
    " could be different... just in case, set the title
    call s:SetTitle()
    " check if we have a valid connection
    if &titlestring == '@' || &titlestring == ""
      " upsy, not connected
      let s:connected = 0
    else
      " well one, we're stil connected
      let s:connected = 1
    endif
    " rebuild vorax db explorer
    call s:RebuildDbExplorer()
    call s:ShowErrors()
    if g:vorax_resultwin_clear
      " because we clear the window we do not want two empty lines
      " at the very beginning of the result window
      let s:last_truncated = 1
    else
      " this means the result is appended to the content of the
      " result window therefore we need an empty line above
      let s:last_truncated = 0
    endif
    " set status
    redraw
    echo g:vorax_messages['done']
  else
    " this is an workaround to automatically simulate a key stroke and, as such,
    " to trigger the CursorHold autocommand
    call feedkeys("f\e")  
  endif
endfunction

" read all output from the interface
function! s:ReadAll()
  let result = []
  let truncated = 0
  if s:interface.more
    " collect results
    while 1
      let buffer = s:interface.read()
      if truncated == 1 && len(buffer) > 0 && len(result) > 0
        let result[-1] = result[-1] . buffer[0]
        call remove(buffer, 0)
      endif
      call extend(result, buffer)
      let truncated = s:interface.truncated
      if !s:interface.more
        break
      endif
      sleep 50m
    endwhile
  endif
  return result
endfunction

" Set the title of the vim window to the user@db string. This
" function is called after connecting to a target database but
" also after executing an SQL statement. That's because the user
" can also issue a connect as sqlcommand, not necessarly as a 
" VoraxConnect vim command.
function! s:SetTitle()
  silent! call s:log.trace('start of s:SetTitle')
  let result = []
  " we don't use vorax#Exec here because that function checks if
  " the user is connected and this is decided according to the
  " current title.
  call s:interface.send(s:interface.pack("prompt &_USER@&_CONNECT_IDENTIFIER"))
  if s:interface.last_error == ""
    let result = s:ReadAll()
    " set the title
    if len(result) > 0
      silent! exec s:log.debug('set title to: ' . result[0])
      let &titlestring = result[0]
    endif
  else
    " an error has occured
    silent! exec s:log.error(s:interface.last_error)
    let &titlestring = '@'
  endif
  silent! call s:log.trace('end of s:SetTitle')
endfunction

" Get the under cursor statemnt boundaries. It returns
" an array with [start_line, start_col, stop_line, stop_col, statement, relpos].
" The meaning of these values are:
" start_line => the line where the current statement begins
" start_col => the column where the current statement begins
" stop_line => the line where the current statement ends
" stop_col => the column where the current statement ends
" statement => the text of the statement
" relpos => the absolute position of the cursor witin the current statement
function! vorax#UnderCursorStatement()
  silent! call s:log.trace('start of vorax#UnderCursorStatement')
  let old_wrapscan=&wrapscan
  let &wrapscan = 0
  let old_search=@/
  let old_line = line('.')
  let old_col = col('.')
  " start of the statement
  let start_line = 0
  let start_col = 0
  " end of the statement
  let stop_line = 0
  let stop_col = 0
  while (start_line == 0)
    let result = search(';\|\/', 'beW')
    if result
      if synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") == ""
        " if the delimitator is not within quotes or comments
        normal l
        let start_line = line('.')
        let start_col = col('.')
      endif
    else
      " set the begining of the statement at the very
      " beginning of the buffer content
      let start_line = 1
      let start_col = 1
    endif
  endwhile
  while (stop_line == 0)
    let result = search(';\|\/', 'Wc')
    if result
      if synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") == ""
        " if the delimitator is not within quotes or comments
        let stop_line = line('.')
        let stop_col = col('.')
      endif
    else
      " set the begining of the statement at the very
      " beginning of the buffer content
      normal G$
      let stop_line = line('.')
      let stop_col = col('.') 
    endif
  endwhile
  " extract the actual statement
  let statement = ""
  for line in getline(start_line, stop_line)
    let statement .= line . "\n"
  endfor
  let statement = strpart(statement, start_col-1, strlen(statement) - (strlen(getline(stop_line)) - stop_col))
  " get rid of the final \n
  let statement = substitute(statement, '\n$', '', '')
  " restore the old pos
  call cursor(old_line, old_col)
  " compute relative pos
  let rel_line = old_line - start_line + 1
  let rel_pos = 1
  let i = 1
  for line in split(statement, '\n', 1)
    if i == rel_line
      let rel_pos += old_col - 1
      break
    else
      " if length is 0 then it must be an empty line which is
      " counted as \n
      let rel_pos += (strlen(line) == 0 ? 1 : strlen(line))
    endif
    let i += 1
  endfor
  let &wrapscan=old_wrapscan
  let @/=old_search
  let retval = [start_line, start_col, stop_line, stop_col, statement, rel_pos]
  silent! call s:log.trace('end of vorax#UnderCursorStatement: returned value=' . string(retval))
  return retval
endfunction

" Executes the provided sql command. If a:show is 1 then the output
" is displayed within the results window. If a:show is 0 then nothing is
" displayed but the result is returned as an array of lines. The big
" diference between these two methods is that the first method executes
" asynchronically, unlike the second one which will wait till the 
" statements completes and all output is fetched. So, do not try to
" execute commands which requires user input using the sync method
" because the call will indefinitelly wait for statement to complete.
function! vorax#Exec(cmd, show)
  silent! call s:log.trace('start of vorax#Exec(cmd)')
  silent! call s:log.debug('cmd='.a:cmd)
  let result = []
  if s:connected
    if s:interface.more
      throw "VRX-1: " . g:vorax_messages['still_executing']
    else
      let dbcommand = a:cmd
      if dbcommand == ''
        " the command is not provided... assume the under cursor
        " statement
        silent! call s:log.debug('No statement provided. Compute the one under cursor.')
        let stmt = vorax#UnderCursorStatement()
        " visual select the current statement
        exe 'silent! norm! ' . stmt[0] . 'G0'. (stmt[1] > 1 ? stmt[1] . 'l' : '') . 
              \ 'v' . stmt[2] . 'G0' . stmt[3] . 'l'
        let dbcommand = stmt[4]
        silent! call s:log.debug('statement='.dbcommand)
      endif
      " remove trailing blanks from cmd
      let dbcommand = substitute(dbcommand, '\_s*\_$', '', 'g')
      " add the delimitator
      let dbcommand = dbcommand . s:Delimitator(dbcommand) . "\n"
      " executes the sql file
      call s:interface.send(s:interface.pack(dbcommand))
      if s:interface.last_error == ""
        if a:show
          let s:processed_plsql_objects = s:ModulesInfo(dbcommand)
          let s:exec_from_buffer = bufnr('%')
          " display results asynchronically
          call s:ShowResults()
        else
          let result = s:ReadAll()
        endif
      else
        silent! call s:log.error(s:interface.last_error)
        call s:EchoErr(g:vorax_messages['unexpected_error'])
      endif
    endif
  else
    call s:EchoErr(g:vorax_messages['not_connected'])
  endif
  return result
  silent! call s:log.trace('end of vorax#Exec')
endfunction

" Disconnects the current connection by shutdown the interface
function! vorax#Disconnect()
  silent! call s:log.trace('start of vorax#Disconnect')
  call s:interface.shutdown()
  " we don't want this to be called for every buffer therefore
  " we deregister the VimLeave autocommand after the first run
  autocmd! VoraX VimLeave *
  silent! call s:log.trace('end of vorax#Disconnect')
endfunction

" Get the currently selected block.
function! vorax#SelectedBlock() range
    let save = @"
    silent normal gvy
    let vis_cmd = @"
    let @" = save
    return vis_cmd
endfunction 

" Get the content of the current buffer
function! s:BufferContent()
  let lines = getline(0, line('$'))
  let content = ""
  for line in lines
    let content .= line . "\n"
  endfor
  return content
endfunction

" execute the current buffer
function! vorax#ExecBuffer()
  if &ft == 'sql'
    let content = s:BufferContent()
    let content .= s:Delimitator(content)
    " go to the beginning of the buffer. This is importat,
    " especially when computing error line numbers in
    " quickfix window
    normal gg
    call vorax#Exec(content, 1)
  else
    call s:EchoErr(g:vorax_messages['wrong_buffer'])
  endif
endfunction

" Connects to the provided database using the cstr
" connection string. The cstr has the common sqlplus
" format user/password@db [as sys(dba|asm|oper). It also
" accepts incomplete formats like user@db or just user, the
" user being prompted afterwards for the missing parts.
function! vorax#Connect(cstr)
  silent! call s:log.trace('start of vorax#Connect(cstr)')
  silent! call s:log.debug('cstr='.cstr)
  let all_cmd = ""
  let s:cdata = s:PromptCredentials(a:cstr)
  let connect_cmd = "connect " . s:cdata['user']
  if s:cdata['osauth']
    let connect_cmd .= " " . s:cdata['db']
  else
    let connect_cmd .= "@" . s:cdata['db']
  endif
  call s:interface.startup()
  " defines the _O_VERSION sqlplus variable. this is needed
  " because in case the autentication fails this variable
  " will not be automatically defined and we'll be prompted
  " for its value when we are about to show it after the
  " connect attempt.
  let all_cmd .= "define _O_VERSION='not connected.'\n"
  " add the actual connect statement
  let all_cmd .= connect_cmd . "\n"
  " add commands to initialize/set the sqlplus environment.
  let cmds = split(g:vorax_sqlplus_header, '\n')
  for cmd in cmds
    let all_cmd .= cmd . "\n"
  endfor
  " show information about the target database to which the user
  " connected to
  let all_cmd .= "prompt &_O_VERSION\n"
  " execute statements
  call s:interface.send(s:interface.pack(all_cmd))
  " send the password. It was not included into the connect
  " statement for security reasons. Pack function provided
  " by the interface usually writes everything into a temp
  " sql file and we don't want sensitive info stored anywhere.
  call s:interface.send(s:cdata['passwd'])
  call s:ShowResults()
  " registers an autocommand to shutdown the interface when vim exits
  autocmd VoraX VimLeave * call vorax#Disconnect()
  silent! call s:log.trace('end of vorax#Connect(cstr)')
endfunction

" Save the current sqlplus settings. This may be used before using
" internal queries which must change the sqlplus environment (e.g.
" SET HEAD OFF) in order to be able to restore them at the end of
" the query.
function! vorax#saveSqlplusSettings()
  call vorax#Exec('store set ' . s:temp_settings_file . ' replace', 0)
endfunction

" Restore a previous saved sqlplus environment.
function! vorax#restoreSqlplusSettings()
  call vorax#Exec('@' . s:temp_settings_file, 0)
endfunction

" Opens the db explorer window
function! vorax#DbExplorer()
  if bufnr('^' . s:db_explorer_title . "$") == -1
    call VrxTree_NewTreeWindow(&titlestring, 
                            \  s:db_explorer_title, 
                            \  1, 
                            \  g:vorax_dbexplorer_side, 
                            \  g:vorax_dbexplorer_width, 
                            \  30, 
                            \ 'Vorax_DbExplorerInit')
  else
    call VrxTree_ToggleTreeWindow(s:db_explorer_title)
  endif
  redraw!
endfunction

" Get info about the modules from the cmd. It returns a list
" of dictionary entries with the following keys: 
"   owner => the owner of the plsql module... empty if no owner
"            was specified
"   object => the plsql module name
"   type => the type of the module (e.g. PACKAGE, PACKAGE BODY etc.)
"   start_line => the line where this module is defined in a:cmd
" These analisis are done using ANTLR3 and are gathered for displaying
" compilation errors and link to the right line within the buffer.
function! s:ModulesInfo(cmd)
  let info = []
  ruby << EOF
    input = ANTLR3::StringStream.new(VIM::evaluate('a:cmd').upcase)
    lexer = PlsqlBlock::Lexer.new(input)
    lexer.map 
    lexer.oracle_modules.each do |m|
      cmd = "call add(info, {'start_line':#{m[:start_line]}, 'owner' : '#{m[:owner]}', 'object' : '#{m[:object]}', 'type' : '#{m[:type]}' })"
      VIM::command(cmd)
    end
EOF
  return info
endfunction

" Internal function to sort error items in the
" quickfix window
function! s:CompareQuickfixEntries(i1, i2)
  if a:i1.lnum == a:i2.lnum && a:i1.col == a:i2.col
    return 0
  elseif a:i1.lnum == a:i2.lnum && a:i1.col < a:i2.col
    return -1
  elseif a:i1.lnum == a:i2.lnum && a:i1.col > a:i2.col
    return 1
  elseif a:i1.lnum < a:i2.lnum
    return -1
  else
    return 1
  endif
endfunction

" Show errors for all create plsql modules, if any
function! s:ShowErrors()
  let in_clause = ""
  " we rely on the s:processed_plsql_objects array which contains all the
  " information about the plsql modules created/altered at the last exec
  for item in s:processed_plsql_objects
    " build up a nice IN filter which will be used to query the errors
    " table from the database
    let in_clause .= "decode('" . item['owner'] . "', '', SYS_CONTEXT('USERENV', 'SESSION_USER'), '" . 
                    \ item['owner'] . "') || '." . item['object'] . "." . item['type'] . "',"
  endfor
  if in_clause != ""
    "get rid of the final comma and add brackets
    let in_clause = '(' . strpart(in_clause, -1, strlen(in_clause)) . ')'
    " build up the final query... All queried fields are separated by our 
    " custom --> separator and we'll be use that to split the items, later
    let query = "select line || '-->' || position || '-->' || owner || '-->' " .
                  \ "|| name || '-->' || type || '-->' || " .
                  \ "replace(replace(text, chr(10), ' '), '\', '\\') " .
                  \ "from all_errors " .
                  \ "where owner || '.' || name || '.' || type in " . in_clause .
                  \ " order by line, position "
    call vorax#saveSqlplusSettings()
    let result = vorax#Exec(vorax#safeForInternalQuery() .
                          \ query . ";\n"
                          \ , 0)
    call vorax#restoreSqlplusSettings()
    let qerr = []
    for error in result
      let parts = split(error, '-->')
      if len(parts) == 6
        " we expect 6 fields
        let start_module_line = 0
        " find out the correspondence between the record error from
        " ALL_ERRORS and the position of the plsql block in our buffer
        for element in s:processed_plsql_objects
          let owner = element['owner']
          if owner == ""
            " if no owner then it's the currently connected one, we
            " can get it from the title
            let title = split(&titlestring, '@')
            if len(title) > 0
              let owner = title[0]
            endif
          endif
          " match the entry from the db with the one from the buffer
          " source info
          if owner ==? parts[2] && element['object'] ==? parts[3] && element['type'] ==? parts[4]
            " start_module_line contains the line number where the plsql
            " block is declared
            let start_module_line = element['start_line'] - 1
            break
          endif
        endfor
        " get the current line number within the exec buffer
        let wnr = bufwinnr(s:exec_from_buffer)
        " focus the exec buffer
        exe wnr . "wincmd w"
        let crr_line = line('.') - 1
        " add this error to our error list
        let qerr += [{'bufnr' : s:exec_from_buffer, 'lnum' : str2nr(parts[0]) + crr_line + start_module_line, 
                    \ 'col' : str2nr(parts[1]), 'text' : parts[5]}]
      endif
    endfor
    let qerr = sort(qerr, 's:CompareQuickfixEntries')
    call setqflist(qerr, 'r')
    if len(qerr) > 0
      " show the error window only if we have errors
      botright cwindow
    else
      cclose
    endif
  endif
endfunction

" This function is used to replace placeholders from resource strings. The
" placeholder format is {#}
function! vorax#translate(rs, ...)
  let str = a:rs
  let i = 1
  while str =~ '{#}'
    if i > a:0
      " we're out of placeholder values
      break
    endif
    let str = substitute(str, '{#}', a:{i}, '')
    let i += 1
  endwhile
  return str
endfunction

" This function returns the sqlplus commands which should be executed
" before running an internal VoraX query (e.g. dbexplorer, code completion etc.).
" This is needed because the sqlplus connection is shared between the user and
" the internal components of VoraX. Therefore, if the user configures for
" example an autotrace that will not be suitable for VoraX future internal
" queries. That means that several options must be always set before trying to
" get anything from sqlplus.
function! vorax#safeForInternalQuery()
  let opts = "set feedback off\n" .
          \  "set autotrace off\n" .
          \  "set pagesize 9999\n" .
          \  "set heading off\n" .
          \  "set linesize 10000\n" .
          \  "set emb on pages 0 newp none\n" 
  return opts
endfunction

" Describes the provided database object. If no object is given then the
" word under cursor is used.
function! vorax#Describe(object)
  let object = a:object
  if object == ""
    let isk_bak = &isk
    " the $ and # should be considered as part of an word
    set isk=@,48-57,_,$,#
    let object = expand('<cword>')
    exe 'set isk=' . isk_bak
  endif
  call vorax#saveSqlplusSettings()
  let result = vorax#Exec(vorax#safeForInternalQuery() .
        \ "set linesize 100\n" .
        \ 'desc ' . object . ";\n" 
        \ , 0)
  call vorax#restoreSqlplusSettings()
  call s:FocusResultsWindow()
  " clear the result window?
  if g:vorax_resultwin_clear
    normal ggdG
  endif
  normal G$
  call append(line('$'), result)
endfunction

" Initialize a VoraX buffer
function vorax#InitBuffer()
  let bufext = fnamemodify(bufname('%'), ':e')
  echo bufext
  for item in g:vorax_dbexplorer_file_extensions
    if bufext =~? item.ext || bufext == 'sql'
      " init code completion
      exe 'set ft=sql'
      setlocal omnifunc=Vorax_Complete
      break
    endif
  endfor
endfunction
