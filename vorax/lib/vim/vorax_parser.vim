" Description: Parsing stuff for VoraX
" Mainainder: Alexandru Tica <alexandru.tica.at.gmail.com>
" License: Apache License 2.0

" no multiple loads allowed
if exists("g:vorax_parsing")
  finish
endif

" Mark as loaded
let g:vorax_parsing = 1

" Parser object reference
let s:parser = {}

" Get info about the modules from the cmd. It returns a list
" of dictionary entries with the following keys: 
"   owner => the owner of the plsql module... empty if no owner
"            was specified
"   object => the plsql module name
"   type => the type of the module (e.g. PACKAGE, PACKAGE BODY etc.)
"   start_line => the line where this module is defined in a:cmd
" These analisis are done using ANTLR3 and are gathered for displaying
" compilation errors and link to the right line within the buffer.
function s:parser.ModulesInfo(cmd) dict
  let info = []
  ruby << EOF
    input = ANTLR3::StringStream.new(VIM::evaluate('a:cmd').upcase)
    lexer = PlsqlBlock::Lexer.new(input)
    lexer.map 
    lexer.oracle_modules.each do |m|
      cmd = "call add(info, {'start_line':#{m[:start_line]}, 'owner' : '#{m[:owner]}', 'object' : '#{m[:object]}', 'type' : '#{m[:type]}', 'in_body' : '#{m[:in_body]}' })"
      VIM::command(cmd)
    end
EOF
  return info
endfunction

" Get info about the submodules(functions/procs) from the pkg. It returns a list
" of dictionary entries with the following keys: 
"   object => the plsql module name
"   type => the type of the module (e.g. PACKAGE, PACKAGE BODY etc.)
"   start_line => the line where this module is defined in a:cmd
" These analisis are done using ANTLR3 and are gathered for displaying
" compilation errors and link to the right line within the buffer.
function s:parser.SubmodulesInfo(pkg) dict
  let info = []
  ruby << EOF
    input = ANTLR3::StringStream.new(VIM::evaluate('a:pkg').upcase)
    lexer = Submodule::Lexer.new(input)
    lexer.map 
    lexer.oracle_submodules.each do |m|
      cmd = "call add(info, {'start_line':#{m[:start_line]}, 'object' : '#{m[:object]}', 'type' : '#{m[:type]}'})"
      VIM::command(cmd)
    end
EOF
  return info
endfunction

" Get columns for the current position which might be comming from
" an alias specified in prefix. Returns a row list of columns. Some
" columns might be in the form of OBJECT.TABLE.*. These has to be further
" fetched using s:ExpandColumns(cols).
function s:parser.ColumnsFromAlias(statement, alias, prefix) dict
  let stmt = a:statement
  let columns = []
  ruby << EOF
    AliasResolver.columns_for(VIM::evaluate('stmt[4]').upcase, VIM::evaluate('stmt[5]').to_i - 1, VIM::evaluate('a:alias')).each do |col|
      VIM::command('call add(columns, \'' + col + '\')')
    end
EOF
  let columns = s:ExpandColumns(columns, a:prefix)
  if a:prefix != ""
    "filter columns
    let i = 0
    for col in copy(columns)
      if col !~? '^' . a:prefix
        call remove(columns, i)
      else
        let i += 1
      endif
    endfor
  endif
  return sort(columns)
endfunction

" Expand columns provided as TABLE.*. This function is used for expanding
" aliases.
function s:ExpandColumns(cols, prefix)
  let columns = []
  for col in a:cols
    if col =~ '\.\*$'
      " get rid of the last .*
      let col = substitute(col, '\.\*$', "", "")
      " this has to be expanded
      let parts = split(col, '\.')
      if len(parts) == 1
        " expand a local object
        let info = s:db.ResolveDbObject(parts[0])
        if has_key(info, 'schema')
          call extend(columns, s:parser.Columns(info.schema, info.object, "", a:prefix))
        endif
      elseif len(parts) == 2
        " expand an object with a schema specified
        call extend(columns, s:parser.Columns(toupper(parts[0]), toupper(parts[1]), "", a:prefix))
      endif
    else
      let columns += [col]
    endif
  endfor
  return columns
endfunction

" Get all columns which starts with the provided pattern
" from the given owner.table object.
function s:parser.Columns(owner, table, pattern, prefix) dict
  let col = ""
  if s:utils.IsLower(a:prefix)
    let col = "lower(column_name)"
  else
    let col = "column_name"
  endif
  let owner = a:owner
  if owner == ""
    let owner = "user"
  else
    let owner = "'" . owner . "'"
  endif
  let result = vorax#Exec(
        \ "set linesize 100\n" .
        \ "select " . col . " from all_tab_columns " . 
        \ "where owner=" . owner . 
        \ " and table_name='" . a:table . "'" .
        \ " and column_name like '" . toupper(a:pattern) . "%' " .
        \ " order by column_id;" 
        \ , 0, "")
  return result
endfunction

" Get the parser object
function Vorax_ParserToolkit()
  if !exists('s:utils')
    let s:utils = {}
    let s:utils = Vorax_UtilsToolkit()
  endif
  if !exists('s:db')
    let s:db = {}
    let s:db = Vorax_DbLayerToolkit()
  endif
  return s:parser
endfunction
