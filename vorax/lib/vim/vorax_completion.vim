" Description: Code completion for VoraX
" Mainainder: Alexandru Tica <alexandru.tica.at.gmail.com>
" License: Apache License 2.0

" no multiple loads allowed
if exists("g:vorax_completion")
  finish
endif

" flag to signal this source was loaded
let g:vorax_completion = 1

function! Vorax_Complete(findstart, base)
  " First pass through this function determines how much of the line should
  " be replaced by whatever is chosen from the completion list
  if a:findstart
    " Locate the start of the item, including "."
    let line     = getline('.')
    let start    = col('.') - 1
    let complete_from = -1
    let s:prefix   = ""
    let s:params = 0
    let s:crr_statement = vorax#UnderCursorStatement()
    while start > 0
      if strpart(s:crr_statement[4], 0, s:crr_statement[5] - 1) =~ '[(,]\_s*$'
        " parameters completion
        let s:params = 1
        break
      endif
      if line[start - 1] !~ '\w\|[$#.,(]'
        " If the previous character is not a period or word character
        break
      elseif line[start - 1] =~ '\w\|[$#]'
        " If the previous character is word character continue back
        let start -= 1
      elseif line[start - 1] =~ '\.' 
        if complete_from == -1
          let complete_from = start
        endif
        let start -= 1
      else
        break
      endif
    endwhile
    if complete_from != -1
      let s:prefix = strpart(line, start, complete_from - start)
    endif
    "call s:CreateCompleteContext()
    return complete_from == -1 ? start : complete_from
  else
    let result = []
    let parts = split(s:prefix, '\.')
    ruby puts VIM::evaluate('string(parts)')
    ruby puts VIM::evaluate('s:params')
    if len(parts) == 0 && s:params == 0 && a:base != ""
      " completion for a local object
      let result = s:SchemaObjects("", a:base)
    elseif s:params == 1
      "complete procedure parameters
      let result = s:CurrentArguments()
    elseif len(parts) == 1
      " we have a prefix which can be: an alias, an object, a schema... we can't tell
      " for sure therefore we'll try in this order

      " check for an alias
      let result = s:ColumnsFromAlias(parts[0], a:base)
      if len(result) == 0
        " no alias could be resolved... go on
        let info = s:ResolveDbObject(parts[0])
        if has_key(info, 'schema') 
          if info.type == 2 || info.type == 4
            " complete columns
            let result = s:Columns(info.schema, info.object, a:base)
          elseif info.type == 9 || info.type == 13
            " complete proc/func from the package/type
            let result = s:Submodules(info.schema, info.object, a:base)
          endif
        else
          " it may be a schema name
          let result = s:SchemaObjects(toupper(parts[0]), a:base)
        endif
      endif
    elseif len(parts) == 2
      " we can have here someting like owner.object
      let info = s:ResolveDbObject(parts[0] . '.' . parts[1])
      ruby puts VIM::evaluate('string(info)')
      if has_key(info, 'schema') 
        if info.type == 2 || info.type == 4
          " complete columns
          let result = s:Columns(info.schema, info.object, a:base)
        elseif info.type == 9 || info.type == 13
          " complete proc/func from the package/type
          let result = s:Submodules(info.schema, info.object, a:base)
        endif
      endif
    endif
    return result
  endif  
endfunction

" Get parameter for the given module/submodule. If module is empty then
" the parameters for a standalone function/procedure is returned.
function s:ParamsFor(owner, module, submodule)
  ruby puts "owner=#{VIM::evaluate('a:owner')} module=#{VIM::evaluate('a:module')} submodule=#{VIM::evaluate('a:submodule')}"
  if s:IsLower(a:submodule)
    let arg = 'lower(argument_name)'
    let type = 'lower(data_type)'
  else
    let arg = 'argument_name'
    let type = 'data_type'
  endif
  call vorax#saveSqlplusSettings()
  let result = vorax#Exec(vorax#safeForInternalQuery() .
        \ "set linesize 100\n" .
        \ "select " . arg . " || ' => ' || '::' || " . type . " || '::' || overload from all_arguments " . 
        \ "where owner='" . a:owner . "'" .
        \ (a:module != "" ? " and package_name ='" . a:module . "'" : "") .
        \ " and object_name ='" . toupper(a:submodule) . "'" .
        \ " and argument_name is not null " .
        \ " order by overload, position;" 
        \ , 0)
  call vorax#restoreSqlplusSettings()
  return result
endfunction

" Get func/proc parameters corresponding to the current position.
function s:CurrentArguments()
  let stmt = s:crr_statement
  let args = []
  let result = []
  let on_fnc = ""
  ruby << EOF
    f = ArgumentResolver.arguments_for(VIM::evaluate('stmt[4]').upcase, VIM::evaluate('stmt[5]').to_i - 1)
    VIM::command("let on_fnc = '" + f + "'") if f
EOF
  if on_fnc != ""
    let fields = split(on_fnc, '\.')
    if len(fields) == 1
      " a procedure, or a function
      let info = s:ResolveDbObject(fields[0])
      if has_key(info, 'schema') || info['schema'] != "" || info['object'] != ""
        let result = s:ParamsFor(info['schema'], '', info['object'])
      endif
    elseif len(fields) == 2
      " could be a package name + procedure or an owner + procedure
      let info = s:ResolveDbObject(fields[0])
      if has_key(info, 'schema') || info['schema'] != "" || info['object'] != ""
        if info['type'] == 9
          " a package 
          let result = s:ParamsFor(info['schema'], info['object'], toupper(fields[1]))
        elseif info['type'] == 7 || info['type'] == 8
          " procedure/function with owner
          let result = s:ParamsFor(info['schema'], '', info['object'])
        end
      endif
    elseif len(fields) == 3 
      " owner + package + proc/func
      let info = s:ResolveDbObject(fields[0] . '.' . fields[1])
      ruby puts VIM::evaluate('string(info)')
      if has_key(info, 'schema') || info['schema'] != "" || info['object'] != ""
        let result = s:ParamsFor(info['schema'], info['object'], toupper(fields[2]))
      endif
    endif
    for row in result
      let fields = split(row, '::', 1)
      call add(args, {'word' : fields[0], 'kind' : fields[1], 'dup' : 1, 'menu' : fields[2] == "" ? "" : "o" . fields[2] })
    endfor
  endif
  return args
endfunction

" Get columns for the current position which might be comming from
" an alias specified in prefix. Returns a row list of columns. Some
" columns might be in the form of OBJECT.TABLE.*. These has to be further
" fetched using s:ExpandColumns(cols).
function s:ColumnsFromAlias(alias, prefix)
  let stmt = s:crr_statement
  let columns = []
  ruby << EOF
    AliasResolver.columns_for(VIM::evaluate('stmt[4]').upcase, VIM::evaluate('stmt[5]').to_i - 1, VIM::evaluate('a:alias')).each do |col|
      VIM::command('call add(columns, \'' + col + '\')')
    end
EOF
  let columns = s:ExpandColumns(columns)
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
function s:ExpandColumns(cols)
  let columns = []
  for col in a:cols
    if col =~ '\.\*$'
      " get rid of the last .*
      let col = substitute(col, '\.\*$', "", "")
      " this has to be expanded
      let parts = split(col, '\.')
      if len(parts) == 1
        " expand a local object
        let info = s:ResolveDbObject(parts[0])
        if has_key(info, 'schema')
          call extend(columns, s:Columns(info.schema, info.object, ""))
        endif
      elseif len(parts) == 2
        " expand an object with a schema specified
        call extend(columns, s:Columns(toupper(parts[0]), toupper(parts[1]), ""))
      endif
    else
      let columns += [col]
    endif
  endfor
  return columns
endfunction

" this function returns 1 if the first char from a:str is lower,
" or 0 otherwise. It is used in completion functions to determine
" how the items should be returned: upper or lower.
function s:IsLower(str)
  if a:str[0] == tolower(a:str[0])
    return 1
  else
    return 0
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
function s:ResolveDbObject(object)
  call vorax#saveSqlplusSettings()
  let result = vorax#Exec(vorax#safeForInternalQuery() .
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
        \ , 0)
  call vorax#restoreSqlplusSettings()
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
  return info
endfunction

" Get user db objects which matches the provided pattern.
function s:SchemaObjects(schema, pattern)
  let obj = ""
  if s:IsLower(a:pattern)
    let obj = "lower(object_name)"
  else
    let obj = "object_name"
  endif
  if a:schema == ""
    let schema = "user, 'PUBLIC'"
  else
    let schema = "'" . a:schema . "'"
  endif
  call vorax#saveSqlplusSettings()
  let result = vorax#Exec(vorax#safeForInternalQuery() .
        \ "set linesize 100\n" .
        \ "select distinct " . obj . " || '::' || " .
        \ "       decode(t2.object_type, '', t1.object_type, t2.object_type) " .
        \ "  from (select owner, object_name, object_type " .
        \ "          from all_objects o1 " .
        \ "         where object_name like '" . toupper(a:pattern) . "%' " .
        \ "           and owner in (" . schema . ") " .
        \ "           and object_type in ('TABLE', " .
        \ "                               'VIEW', " .
        \ "                               'SYNONYM', " .
        \ "                               'PROCEDURE', " .
        \ "                               'FUNCTION', " .
        \ "                               'PACKAGE', " .
        \ "                               'TYPE')) t1, " .
        \ "       (select s.owner, s.synonym_name, o.object_type " .
        \ "          from all_synonyms s, all_objects o " .
        \ "         where s.owner in (" . schema . ") " .
        \ "           and s.table_owner = o.owner " .
        \ "           and s.table_name = o.object_name " .
        \ "           and s.synonym_name like '". toupper(a:pattern) . "%') t2 " .
        \ " where t1.owner = t2.owner(+) " .
        \ "   and t1.object_name = t2.synonym_name(+) " .
        \ " order by 1; "
        \ , 0)
  call vorax#restoreSqlplusSettings()
  let items = []
  for row in result
    let fields = split(row, '::')
    let kind = ""
    if fields[1] == 'TABLE'
      let kind = "tbl"
    elseif fields[1] == 'VIEW'
      let kind = "viw"
    elseif fields[1] == 'SYNONYM'
      let kind = "syn"
    elseif fields[1] == 'PROCEDURE'
      let kind = "prc"
    elseif fields[1] == 'FUNCTION'
      let kind = "fnc"
    elseif fields[1] == 'PACKAGE'
      let kind = "pkg"
    elseif fields[1] == 'TYPE'
      let kind = "typ"
    endif
    call add(items, {'word' : fields[0], 'kind' : kind })
  endfor
  return items
endfunction

" Get all columns which starts with the provided pattern
" from the given owner.table object.
function s:Columns(owner, table, pattern)
  let col = ""
  if s:IsLower(s:prefix)
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
  call vorax#saveSqlplusSettings()
  let result = vorax#Exec(vorax#safeForInternalQuery() .
        \ "set linesize 100\n" .
        \ "select " . col . " from all_tab_columns " . 
        \ "where owner=" . owner . 
        \ " and table_name='" . a:table . "'" .
        \ " and column_name like '" . toupper(a:pattern) . "%' " .
        \ " order by column_id;" 
        \ , 0)
  call vorax#restoreSqlplusSettings()
  return result
endfunction

" Get all procedures/functions for the provided plsql module
" (package/type). Only the submodules which matches the given
" pattern are returned
function s:Submodules(owner, module, pattern)
  let sm = ""
  if s:IsLower(s:prefix)
    let sm = "lower(procedure_name)"
  else
    let sm = "procedure_name"
  endif
  call vorax#saveSqlplusSettings()
  let result = vorax#Exec(vorax#safeForInternalQuery() .
        \ "set linesize 100\n" .
        \ "select " . sm . " from all_procedures " .
        \ "where owner='" . a:owner . "'" .
        \ " and object_name='" . a:module . "'" . 
        \ " and procedure_name like '".toupper(a:pattern)."%' " . 
        \ "order by subprogram_id;"
        \ , 0)
  call vorax#restoreSqlplusSettings()
  return result
endfunction

