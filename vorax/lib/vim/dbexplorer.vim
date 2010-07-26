" Description: The VoraX Database Explorer
" Mainainder: Alexandru Tica <alexandru.tica.at.gmail.com>
" License: Apache License 2.0

" no multiple loads allowed
if exists("g:vorax_dbexplorer")
  finish
endif

" flag to signal this source was loaded
let g:vorax_dbexplorer = 1

" Initialize the tree
function! Vorax_DbExplorerInit()
  let b:VrxTree_GetSubNodesFunction = 'Vorax_DbExplorerGetNodes'
  let b:VrxTree_IsLeafFunction = 'Vorax_DbExplorerIsLeaf'
  let b:VrxTree_ColorFunction="Vorax_InitColors"  
  let b:VrxTree_OnLeafClick="Vorax_DbExplorerClick"
  let b:VrxTree_InitMappingsFunction="Vorax_InitMappings"
  setlocal foldcolumn=0
  setlocal winfixwidth
  setlocal buftype=nofile
  setlocal nobuflisted
  setlocal nospell
  setlocal nonu
  setlocal cursorline
  setlocal noswapfile
endfunction

" Configures some key mappings
function! Vorax_InitMappings()
	noremap <silent> <buffer> o :call VrxTree_OpenNode()<CR>
	noremap <silent> <buffer> R :call VrxTree_RefreshNode()<CR>
endfunction

" Get the nodes corresponding to the provided path
function! Vorax_DbExplorerGetNodes(path)
  if a:path == "" || a:path == "@"
    " no connection available
    return ""
  endif
  if a:path == &titlestring
    return s:GenericCategories(1)
  elseif a:path =~ '^/\?[^/]\+/Users$'
    let result = vorax#Exec("select username from all_users order by 1;", 0)
    return join(result, "\n")
  elseif a:path =~ '^/\?[^/]\+/Users/[^/]\+$'
    return s:GenericCategories(0)
  elseif a:path =~ '^/\?[^/]\+/[^/]\+$' || a:path =~ '^/\?[^/]\+/Users/[^/]\+/[^/]\+$'
    " a generic category under the current user or another one
    let category = s:ObjectType(a:path)
    let user = 'user'
    let parts = split(a:path, b:VrxTree_pathSeparator)
    if len(parts) == 4
      let user = "'" . parts[-2] . "'"
    endif
    let result = vorax#Exec("select object_name from all_objects where owner = " . user . " and object_type = '" . category . "' order by 1;", 0)
    return join(result, "\n")
  elseif a:path =~ '^/\?[^/]\+/Packages/[^/]\+$'
    let package = s:ObjectName(a:path)
    let result = vorax#Exec("select distinct decode(type, 'PACKAGE', 'Spec', 'Body') from user_source where name = '" . package . "' order by 1 desc;\n", 0)
    if result[-1] == 'Body' 
      let result += ['Both']
    endif
    return join(result, "\n")
  endif
endfunction

" Return the generic categories for the DbExplorer tree.
" If a:include_users is 1 then the USERS generic node is
" also returned. Basically, include_users should be 1 if
" the current user is expanded and 0 if object belonging to
" others are browsed.
function s:GenericCategories(include_users)
  let categories = "Tables\n" .
        \  "Views\n" . 
        \  "Procedures\n" .
        \  "Functions\n" . 
        \  "Packages\n" .
        \  "Synonyms\n" .
        \  "Types\n" .
        \  "Triggers\n" .
        \  "Sequences\n" 
  if a:include_users
    let categories .= "Users\n" 
  endif
  return categories
endfunction

" Does the provided node has children?
function! Vorax_DbExplorerIsLeaf(path)
  let parts = split(a:path, b:VrxTree_pathSeparator)
  if type(parts) == 3 && len(parts) >= 3
    if (len(parts) == 3 && parts[-2] == 'Packages') 
        \ || (parts[-1] == 'Users' && len(parts) == 2) 
        \ || (len(parts) == 3 && parts[-2] == 'Users')
        \ || (len(parts) == 4 && parts[1] == 'Users')
      " the package has spec and body
      return 0
    else
      return 1
    endif
  else
    return 0
  endif
endfunction

" Open the database object on click
function! Vorax_DbExplorerClick(path)
  let object_name = s:ObjectName(a:path)
  let subtype = ""
  if object_name == 'Spec' || object_name == 'Body' || object_name == 'Both'
    let subtype = object_name
    let object_name = split(a:path, b:VrxTree_pathSeparator)[2]
  endif
  echon 'Loading ' . object_name . '. Please wait...'
  if a:path =~ '^/\?[^/]\+/[^/]\+/'
    let type = s:ObjectType(a:path)
    let user = 'user'
    if a:path =~ '^/\?[^/]\+/Users'
      let user = "'" . split(a:path, b:VrxTree_pathSeparator)[2] . "'"
    endif 
    if a:path =~ '^/\?[^/]\+/Packages'
      if subtype == 'Spec'
        let type = 'PACKAGE_SPEC'
      elseif subtype == 'Body'
        let type = 'PACKAGE_BODY'
      elseif subtype == 'Both'
        let type = 'PACKAGE'
      endif
    elseif a:path =~ '^/\?[^/]\+/Types'
      if subtype == 'Spec'
        let type = 'TYPE_SPEC'
      elseif subtype == 'Body'
        let type = 'TYPE_BODY'
      elseif subtype == 'Both'
        let type = 'TYPE'
      endif
    endif
    let fname = object_name . '.' . s:ExtensionForType(type)
    let bwn = bufwinnr('^' . fname . '$')
    if bwn == -1
      " no buffer with this name
      let response = ''
      if g:vorax_dbexplorer_object_over_file == 2
        if filereadable(fname)
          let response = input(vorax#translate(g:vorax_messages['dbexpl_edit_file_confirmation'], fname, 'E'))
        endif
      elseif g:vorax_dbexplorer_object_over_file == 1
        let response = 'e'
      endif
      call s:FocusCandidateWindow()
      silent! exe 'edit ' . fname
      call vorax#InitBuffer()
      ":SQLSetType sqloracle
      if response !=? 'e'
        " clear buffer
        normal ggdG
        " get source
        let result = s:GetSource(type, object_name, user)
        call append(0, result)
        " delete the leading blanks from the first line... the dbms_metadata.getddl
        " puts some blanks before the CREATE statement
        :1s/^\s*//
        " clear the previous highlight
        :nohlsearch
        " go to the start of the buffer
        normal gg
      endif
    else
      " just show the window
      exe bwn . 'wincmd w'
    endif
  endif
  redraw
  echo 'Done.'
endfunction

" Get the corresponding file extension for the provided
" object type. The file extension is returned according to
" the g:vorax_dbexplorer_file_extensions variable.
function s:ExtensionForType(type)
  for item in g:vorax_dbexplorer_file_extensions
    if item.type ==? a:type
      return item.ext
    endif
  endfor
  return 'sql'
endfunction

" Nice colors for generic categories
function! Vorax_InitColors () 
  syn match Directory  '\(+\|-\).\+'
  hi link Directory  Comment
endfunction 

" When a db object is about to be opened, we don't want the edit window
" to be layed out randomly, or ontop of special windows like the results
" window. This procedure finds out a suitable window for opening the
" db object. If it cannot find any then a new split will be performed.
function! s:FocusCandidateWindow()
  let winlist = []
  " we save the current window because the after windo we may end up in
  " another window
  let original_win = winnr()
  " iterate through all windows and get info from them
  windo let winlist += [[bufnr('%'),  winnr(), &buftype]]
  for w in winlist
    if w[2] == "nofile" || w[2] == 'quickfix' || w[2] == 'help'
      " do nothing
    else
      " great! we just found a suitable window... focus it please
      exe w[1] . 'wincmd w'
      return
    endif
  endfor
  " if here, then no suitable window was found... we'll create one
  " first of all, restore the old window
  exe original_win . 'wincmd w'
  " split a new window taking into account where the dbexplorer is
  let settings = VrxTree_GetSettings(bufname('%'))
  if settings['vertical']
    " compute how large this window should be
    let span = winwidth(0) - settings['minWidth']
    if settings['side'] == 1
      let splitcmd = 'topleft ' . (span > 0 ? span : "") . 'new'
    elseif settings['side'] == 0
      let splitcmd = 'botright ' . (span > 0 ? span : "") . 'new'
    endif
  else
    " compute how tall this window should be
    let span = winheight(0) - settings['minHeight']
    if settings['side'] == 1
      let splitcmd = 'topleft vertical ' . (span > 0 ? span : "") . 'new'
    elseif settings['side'] == 0
      let splitcmd = 'botright vertical ' . (span > 0 ? span : "") . 'new'
    endif
  endif
  exe splitcmd
endfunction

" Get the object type for the provided path.
function s:ObjectType(path)
  let parts = split(a:path, b:VrxTree_pathSeparator)
  if len(parts) >= 2 && parts[1] != 'Users'
    " under the user tree
    let type = parts[1]
  else
    " under the other users tree
    let type = parts[3]
  endif
  " get rid of the final 's'
  let type = strpart(type, -1, strlen(type))
  let type = toupper(type)
  return type
endfunction

" Get the object name corresponding to the provide path
function s:ObjectName(path)
  return substitute(a:path, '.*/', '', 'g')
endfunction

" Get the source for the provided proc/func/package
function s:GetSource(type, object_name, schema)
  let type = a:type
  let object_name = a:object_name
  let result = []
  let result = vorax#Exec("set long 1000000000 longc 60000\n" .
        \ "set wrap on\n" .
        \ "exec dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', TRUE );\n" .
        \ "exec dbms_metadata.set_transform_param( DBMS_METADATA.SESSION_TRANSFORM, 'BODY', TRUE );\n" .
        \ "select dbms_metadata.get_ddl('" . type . "', '" . object_name . "', " . a:schema . ") from dual;"
        \ , 0)
  " remove empty lines from the begin/end
  let result = s:TrimResult(result)
  return result
endfunction

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
