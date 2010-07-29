" Description: Database layer abstraction for VoraX
" Mainainder: Alexandru Tica <alexandru.tica.at.gmail.com>
" License: Apache License 2.0

" no multiple loads allowed
if exists("g:vorax_dblayer")
  finish
endif

" mark this as loaded
let g:vorax_dblayer = 1

" Enable logging
if g:vorax_debug
  silent! call log#init('ALL', ['~/vorax.log'])
  silent! let s:log = log#getLogger(expand('<sfile>:t'))
endif

" The object reference
let s:db = { 'cdata': {}, 'connected': 0 }

" A temporary file to save to/restore from sqlplus settings
let s:fset = substitute(fnamemodify(tempname(), ':p:h:8'), '\\', '/', 'g') . '/vrx_settings.sql'

" ====== PUBLIC INTERFACE ====== 

" Get the database layer object
function Vorax_DbLayerToolkit()
  if !exists('s:interface')
    let s:interface = {}
    let s:interface = Vorax_GetInterface()
  endif
  if !exists('s:tk_utils')
    let s:tk_utils = {}
    let s:tk_utils = Vorax_UtilsToolkit()
  endif
  return s:db
endfunction

" Connects to the provided database using the cstr
" connection string. The cstr has the common sqlplus
" format user/password@db [as sys(dba|asm|oper). It also
" accepts incomplete formats like user@db or just user, the
" user being prompted afterwards for the missing parts.
function s:db.Connect(cstr) dict
  silent! call s:log.trace('start of s:db.Connect(cstr)')
  silent! call s:log.debug('cstr='.cstr)
  let result = []
  let all_cmd = ""
  let self.cdata = s:PromptCredentials(a:cstr)
  silent! call s:log.debug('cdata='.string(cdata))
  let connect_cmd = self.cdata['user'] . '/' . self.cdata['passwd']
  let status = self.cdata['user']
  if self.cdata['osauth']
    let connect_cmd .= " " . self.cdata['db']
    let status .= " " .self.cdata['db']
  else
    let connect_cmd .= "@" . self.cdata['db']
    let status .= "@" .self.cdata['db']
  endif
  redraw
  let status = s:tk_utils.Translate(g:vorax_messages['connecting'], status)
  let connect_cmd = 'connect ' . connect_cmd
  call s:interface.startup()
  if s:interface.last_error == ""
    silent! call s:log.debug('interface successfully started.')
    " defines the _O_VERSION sqlplus variable. this is needed
    " because in case the autentication fails this variable
    " will not be automatically defined and we'll be prompted
    " for its value when we are about to show it after the
    " connect attempt.
    let all_cmd .= "define _O_VERSION='not connected.'\n"
    " add the actual connect statement
    let all_cmd .= connect_cmd . "\n"
    " show information about the target database to which the user
    " is connected to
    let all_cmd .= "prompt &_O_VERSION\n"
    " add commands to initialize/set the sqlplus environment.
    let cmds = split(g:vorax_sqlplus_header, '\n')
    for cmd in cmds
      let all_cmd .= cmd . "\n"
    endfor
    " save current sqlplus settings and prepare sqlplus for a silent exec
    let save_cmd = 'store set ' . s:fset . " replace\n" .
          \  "set echo off\n" .
          \  "set feedback off\n" .
          \  "set autotrace off\n" .
          \  "set pagesize 9999\n" .
          \  "set heading off\n" .
          \  "set linesize 200\n"
    silent! call s:log.debug('Execute: '. save_cmd)
    call s:interface.send(s:interface.pack(save_cmd))
    if s:interface.last_error == ""
      " if no errors then consume the output
      let output = self.ReadAll(status)
      silent! call s:log.debug('Output: '. string(output))
      " send the command to the interface
      silent! call s:log.debug('Execute: '. all_cmd)
      call s:interface.send(s:interface.pack(all_cmd))
      call s:interface.mark_end()
      if s:interface.last_error == ""
        " if no errors then read the output
        let result = self.ReadAll(status)
        silent! call s:log.debug('Output: '. string(result))
        " restore the previous saved settings
        silent! call s:log.debug('Restore sqlplus settings by running: @' . s:fset)
        call s:interface.send('@' . s:fset)
        " execute header
        silent! call s:log.debug('About to execute header.')
        let all_cmd = ""
        let cmds = split(g:vorax_sqlplus_header, '\n')
        for cmd in cmds
          let all_cmd .= cmd . "\n"
        endfor
        silent! call s:log.debug(all_cmd)
        call s:interface.send(s:interface.pack(all_cmd))
        if s:interface.last_error == ""
          " if no errors then consume the output
          let output = self.ReadAll(status)
          silent! call s:log.debug('Output: '. string(output))
          " check the connection
          let connectedTo = self.ConnectionOwner()
          if connectedTo =~ '^[^@]\+@[^@]\+$'
            let &titlestring = connectedTo
            let self.connected = 1
          endif
        endif
      endif
    endif
  endif
  if s:interface.last_error != ""
    silent! call s:log.error(s:interface.last_error)
    let self.connected = 0
    let &titlestring = "not connected"
    throw 'VRX-CONNECT: ' . s:interface.last_error
  endif
  " rebuild the dbexplorer
  call Vorax_RebuildDbExplorer()
  silent! call s:log.trace('end of s:db.Connect(cstr). Returned value: '. string(result))
  return result
endfunction

" read all output from the interface
function s:db.ReadAll(feedback) dict
  let result = []
  let truncated = 0
  if s:interface.more
    " collect results
    while 1
      let buffer = s:interface.read()
      silent! call s:log.debug('read all buffer='. string(buffer))
      if s:interface.last_error != ""
        " an error has occured... do not continue
        silent! call s:log.error(s:interface.last_error)
        throw 'VRX-READ: ' . s:interface.last_error
      endif
      if truncated == 1 && len(buffer) > 0 && len(result) > 0
        let result[-1] = result[-1] . buffer[0]
        call remove(buffer, 0)
      endif
      call extend(result, buffer)
      let truncated = s:interface.truncated
      if !s:interface.more
        break
      endif
      " show progress informationn... a redraw is needed
      if a:feedback != ""
        redraw
        echon a:feedback . " " . s:tk_utils.BusyIndicator()
      endif
      sleep 50m
    endwhile
  endif
  if a:feedback != ""
    " clear feedback message
    redraw
    echon ''
  endif
  return result
endfunction

" Get the end delimitator. This function tries to guess the
" type of the delimitator according to the given statement. If
" a plsql block is given then a slash is returned otherwise, if
" no ';' is detected then ';' is returned.
function s:db.Delimitator(cmd) dict
  silent! call s:log.trace('s:db.Delimitator(cmd)')
  silent! call s:log.debug('cmd='.string(cmd))
  if a:cmd =~ '\v\n+\s*/\s*\n*$'
    " if an ending slash is found then no delimitator is required
    silent! call s:log.trace('An ending slash was found. No delimitator is returned.')
    return ''
  endif
  if a:cmd =~ '\vend\_s*"?[a-z0-9_$#]*"?\_s*;\_s*\_$'
    " a plsql block was given
    silent! call s:log.trace('A plsql block was found. Return a slash.')
    return "\n/\n"
  elseif a:cmd !~ '\v\_s*;\_s*\_$'
    " a regular sqlplus command. Pay attention that no \n is
    " added in order to cover the sqlplus special commands too.
    " For example, if the command is 'set lines 200' we detect
    " that there's no terminator therefore we add one, but on
    " the same line. It would be wrong in this case to add this
    " terminator on a new line.
    silent! call s:log.trace('A regular sql/sqlplus statement was found. Return ;')
    return ';'
  else
    silent! call s:log.trace('No delimitator is needed.')
    return ''
  endif
endfunction

" This function is used to silently execute a command.
function s:db.Exec(cmd, feedback) dict
  silent! call s:log.trace('start of s:db.Exec(cmd)')
  silent! call s:log.debug('cmd='.a:cmd)
  let result = []
  " save current sqlplus settings and prepare sqlplus for a silent exec
  call s:interface.send(s:interface.pack('store set ' . s:fset . " replace\n" .
        \  "set echo off\n" .
        \  "set feedback off\n" .
        \  "set autotrace off\n" .
        \  "set pagesize 9999\n" .
        \  "set heading off\n" .
        \  "set linesize 10000\n" .
        \  "set emb on pages 0 newp none\n"))
  if s:interface.last_error == ""
    try
      " if no errors then consume the output
      call self.ReadAll(a:feedback)
      " send the command to the interface
      call s:interface.send(s:interface.pack(a:cmd))
      if s:interface.last_error == ""
        " if no errors then read the output
        let result = self.ReadAll(a:feedback)
        " restore the previous saved settings
        call s:interface.send(s:interface.pack('@' . s:fset))
        if s:interface.last_error == ""
          " if no errors then consume the output
          call self.ReadAll(a:feedback)
        endif
      endif
    catch /^VRX-READ/
      silent! call s:log.error(v:exception)
      s:tk_utils.EchoErr(v:exception)
    endtry
  endif
  silent! call s:log.trace('end of s:db.Exec(cmd)')
  return result
endfunction

" Get the user@db for the current connection.
function s:db.ConnectionOwner() dict
  silent! call s:log.trace('start of s:db:ConnectionOwner')
  let result = self.Exec("prompt &_USER@&_CONNECT_IDENTIFIER", "")
  " set the title
  if len(result) > 0
    silent! call s:log.trace('return: ' . result[0])
    return result[0]
  else
    " an error has occured
    silent! call s:log.error(s:interface.last_error)
    return ""
  endif
endfunction

" This function is used to resolve a object name within the database
" context. It returnes a dictionary with the following keys:
"   'schema' => the schema of the object
"   'object' => the actual object
"   'dblink' => the name of the dblink if any
"   'type'   => the type of the object:
"                 2  = tables
"                 4  = views
"                 5  = synonym
"                 7  = procedure
"                 8  = function
"                 9  = packages
"                 13 = types
function s:db.ResolveDbObject(object) dict
  silent! call s:log.trace('start of s:db:ResolveDbObject(object)')
  silent! call s:log.debug('object='.a:object)
  let result = self.Exec(
        \ "set serveroutput on\n" .
        \ "declare\n".
        \ "   type t_context is varray(3) of integer;\n" .
        \ "   schema varchar2(30);\n" .
        \ "   part1 varchar2(30);\n" .
        \ "   part2 varchar2(30);\n" .
        \ "   dblink varchar2(100);\n" .
        \ "   part1_type number;\n" .
        \ "   object_number number;\n" .
        \ "   l_obj varchar2(100);\n" .
        \ "   l_skip boolean := false;\n" .
        \ "   try_ctx t_context := t_context(1, 2, 7);\n" .
        \ "   invalid_context exception;\n" .
        \ "   no_object exception;\n" .
        \ "   pragma exception_init(invalid_context, -04047);\n" .
        \ "   pragma exception_init(no_object, -06564);\n" .
        \ " begin\n" .
        \ "   for ctx in try_ctx.first .. try_ctx.last loop\n" .
        \ "     begin\n" .
        \ "       DBMS_UTILITY.NAME_RESOLVE (\n" .
        \ "          '" . a:object . "', \n" .
        \ "          try_ctx(ctx),\n" .
        \ "          schema, \n" .
        \ "          part1, \n" .
        \ "          part2,\n" .
        \ "          dblink, \n" .
        \ "          part1_type, \n" .
        \ "          object_number);\n" .
        \ "       l_skip := false;\n" .
        \ "     exception\n" .
        \ "       when invalid_context then\n" .
        \ "         l_skip := true;\n" .
        \ "       when no_object then\n" .
        \ "         return;\n" .
        \ "     end;\n" .
        \ "     if l_skip = false then\n" .
        \ "       if part1 is not null then\n" .
        \ "          l_obj := part1;\n" .
        \ "       elsif part1 is null and part2 is not null then\n" .
        \ "          l_obj := part2;\n" .
        \ "       end if;\n" .
        \ "       dbms_output.put_line(schema || '::' || l_obj || '::' || dblink || '::' || part1_type);\n" .
        \ "       return;\n" .
        \ "     end if;\n" .
        \ "   end loop;\n" .
        \ " end;\n" .
        \ "/\n"
        \ , "" )
  let info = {}
  if len(result) > 0
    " we have results
    let record = result[0]
    let fields = split(record, '::')
    if len(fields) == 4
      let info['schema'] = fields[0]
      let info['object'] = fields[1]
      let info['dblink'] = fields[2]
      let info['type'] = fields[3]
    endif
  endif
  silent! call s:log.trace('end of s:db:ResolveDbObject(object). returned value='.string(info))
  return info
endfunction

" Get the source for the provided proc/func/package
function s:db.GetSource(type, object_name, schema) dict
  silent! call s:log.trace('start of s:db:GetSource(type, object_name, schame)')
  silent! call s:log.debug('type='.a:type.' object_name='.a:object_name.' schema='.a:schema)
  let type = a:type
  let object_name = a:object_name
  let result = []
  let result = self.Exec("set long 1000000000 longc 60000\n" .
        \ "set wrap on\n" .
        \ "exec dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE );\n" .
        \ "exec dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM, 'BODY', TRUE );\n" .
        \ "select dbms_metadata.get_ddl('" . type . "', '" . object_name . "', " . a:schema . ") from dual;"
        \ , "Loading source...")
  " remove empty lines from the begin/end
  let result = s:TrimResult(result)
  return result
  silent! call s:log.trace('end of s:db:GetSource(type, object_name, schame)')
endfunction

" Convert the numeric type return by the vorax#resolveDbObject to the textual
" database type representation.
function s:db.DbType(type) dict
  if a:type == 2
    return 'TABLE'
  elseif a:type == 4
    return 'VIEW'
  elseif a:type == 5
    return 'SYNONYM'
  elseif a:type == 7
    return 'PROCEDURE'
  elseif a:type == 8
    return 'FUNCTION'
  elseif a:type == 9
    return 'PACKAGE'
  elseif a:type == 13
    return 'TYPE'
  endif
endfunction

" ====== PRIVATE FUNCTIONS ====== 

" Trim all empty lines from the start/end of the
" provided result
function s:TrimResult(result)
  let result = a:result
  let idx = 0
  for line in result
    if line == ""
      let idx += 1
    else
      break
    endif
  endfor
  if idx > 0
    call remove(result, 0, idx - 1)
  endif
  " remove empty lines from the end
  while len(result) > 0 
    if result[len(result) - 1] == ""
      call remove(result, len(result) - 1)
    else
      break
    endif
  endwhile
  return result
endfunction

" This function is used to parse a connect string. It receives
" a string like 'user/pwd@db' and it breaks it down into the
" corresponding user,pwd,db parts. It returns these components
" into a dictionary structure: 
"   {'user': , 'passwd': , 'db': , 'osauth': }
" The osauth flag is set if the provided connection string is 
" requesting an OS authentication (e.g. / as sysdba).
function s:ParseCstr(cstr) 
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
" the password will be requested. It returns a dictionary similar with
" s:ParseCstr() function.
function s:PromptCredentials(cstr)
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

