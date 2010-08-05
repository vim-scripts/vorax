" Description: Code completion for VoraX
" Mainainder: Alexandru Tica <alexandru.tica.at.gmail.com>
" License: Apache License 2.0

" no multiple loads allowed
if exists("g:vorax_completion")
  finish
endif

" flag to signal this source was loaded
let g:vorax_completion = 1

let s:keywords = [  {'word' : 'ALL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ALTER', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'AND', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ANY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ARRAY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ARROW', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'AS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ASC', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'AT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BEGIN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BETWEEN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CASE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CHECK', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CLUSTERS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CLUSTER', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'COLAUTH', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'COLUMNS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'COMPRESS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CONNECT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CRASH', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CREATE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CURRENT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DECIMAL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DECLARE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DEFAULT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DELETE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DESC', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DISTINCT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DROP', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ELSE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'END', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'EXCEPTION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'EXCLUSIVE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'EXISTS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'FETCH', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'FORM', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'FOR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'FROM', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'GOTO', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'GRANT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'GROUP', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'HAVING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'IDENTIFIED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'IF', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'IN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INDEXES', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INDEX', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INSERT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INTERSECT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INTO', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'IS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LIKE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LOCK', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MINUS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MODE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NOCOMPRESS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NOT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NOWAIT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NULL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OF', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ON', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OPTION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ORDER,OVERLAPS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PRIOR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PROCEDURE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PUBLIC', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RANGE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RECORD', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RESOURCE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'REVOKE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SELECT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SHARE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SIZE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SQL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'START', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SUBTYPE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TABAUTH', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TABLE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'THEN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TO', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TYPE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'UNION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'UNIQUE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'UPDATE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'USE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'VALUES', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'VIEW', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'VIEWS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'WHEN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'WHERE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'WITH', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'A', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ADD', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'AGENT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'AGGREGATE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ARRAY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ATTRIBUTE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'AUTHID', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'AVG', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BFILE_BASE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BINARY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BLOB_BASE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BLOCK', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BODY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BOTH', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BOUND', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BULK', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'BYTE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'C', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CALL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CALLING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CASCADE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CHAR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CHAR_BASE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CHARACTER', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CHARSETFORM', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CHARSETID', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CHARSET', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CLOB_BASE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CLOSE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'COLLECT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'COMMENT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'COMMIT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'COMMITTED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'COMPILED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CONSTANT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CONSTRUCTOR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CONTEXT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CONVERT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'COUNT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CURSOR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'CUSTOMDATUM', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DANGLING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DATA', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DATE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DATE_BASE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DAY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DEFINE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DETERMINISTIC', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DOUBLE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'DURATION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ELEMENT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ELSIF', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'EMPTY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ESCAPE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'EXCEPT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'EXCEPTIONS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'EXECUTE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'EXIT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'EXTERNAL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'FINAL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'FIXED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'FLOAT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'FORALL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'FORCE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'FUNCTION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'GENERAL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'HASH', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'HEAP', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'HIDDEN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'HOUR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'IMMEDIATE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INCLUDING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INDICATOR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INDICES', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INFINITE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INSTANTIABLE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INTERFACE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INTERVAL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'INVALIDATE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ISOLATION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'JAVA', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LANGUAGE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LARGE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LEADING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LENGTH', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LEVEL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LIBRARY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LIKE2', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LIKE4', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LIKEC', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LIMIT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LIMITED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LOCAL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LONG', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'LOOP', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MAP', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MAX', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MAXLEN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MEMBER', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MERGE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MIN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MINUTE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MOD', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MODIFY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MONTH', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'MULTISET', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NAME', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NAN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NATIONAL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NATIVE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NCHAR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NEW', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NOCOPY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'NUMBER_BASE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OBJECT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCICOLL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCIDATETIME', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCIDATE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCIDURATION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCIINTERVAL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCILOBLOCATOR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCINUMBER', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCIRAW', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCIREFCURSOR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCIREF', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCIROWID', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCISTRING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OCITYPE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ONLY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OPAQUE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OPEN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OPERATOR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ORACLE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ORADATA', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ORGANIZATION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ORLANY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ORLVARY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OTHERS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OUT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'OVERRIDING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PACKAGE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PARALLEL_ENABLE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PARAMETER', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PARAMETERS', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PARTITION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PASCAL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PIPE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PIPELINED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PRAGMA', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PRECISION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'PRIVATE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RAISE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RANGE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RAW', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'READ', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RECORD', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'REF', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'REFERENCE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'REM', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'REMAINDER', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RENAME', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RESULT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RETURN', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'RETURNING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'REVERSE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ROLLBACK', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ROW', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SAMPLE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SAVE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SAVEPOINT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SB1', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SB2', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SB4', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SECOND', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SEGMENT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SELF', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SEPARATE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SEQUENCE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SERIALIZABLE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SET', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SHORT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SIZE_T', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SOME', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SPARSE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SQLCODE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SQLDATA', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SQLNAME', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SQLSTATE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'STANDARD', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'STATIC', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'STDDEV', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'STORED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'STRING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'STRUCT', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'STYLE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SUBMULTISET', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SUBPARTITION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SUBSTITUTABLE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SUBTYPE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SUM', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'SYNONYM', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TDO', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'THE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TIME', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TIMESTAMP', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TIMEZONE_ABBR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TIMEZONE_HOUR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TIMEZONE_MINUTE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TIMEZONE_REGION', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TRAILING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TRANSAC', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TRANSACTIONAL', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TRUSTED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'TYPE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'UB1', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'UB2', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'UB4', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'UNDER', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'UNSIGNED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'UNTRUSTED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'USE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'USING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'VALIST', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'VALUE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'VARIABLE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'VARIANCE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'VARRAY', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'VARYING', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'VOID', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'WHILE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'WORK', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'WRAPPED', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'WRITE', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'YEAR', 'kind' : 'kyw', 'dup': 1}, 
                  \ {'word' : 'ZONE', 'kind' : 'kyw', 'dup': 1}   ]

" import libs
runtime! vorax/lib/vim/vorax_utils.vim
runtime! vorax/lib/vim/vorax_dblayer.vim

let s:utils = Vorax_UtilsToolkit()
let s:db = Vorax_DbLayerToolkit()

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
    let s:crr_statement = s:utils.UnderCursorStatement()
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
    return complete_from == -1 ? start : complete_from
  else
    let result = []
    let parts = split(s:prefix, '\.')
    if len(parts) == 0 && s:params == 0 && a:base != ""
      " completion for a local object
      let result = s:SyntaxItems(a:base)
      call extend(result, s:SchemaObjects("", a:base))
      let result = sort(result, "s:CompareEntries")
    elseif s:params == 1
      "complete procedure parameters
      let result = s:CurrentArguments()
    elseif len(parts) == 1
      " we have a prefix which can be: an alias, an object, a schema... we can't tell
      " for sure therefore we'll try in this order

      " check for an alias
      let result = s:ColumnsFromAlias(s:crr_statement, parts[0], a:base)
      if len(result) == 0
        " no alias could be resolved... go on
        let info = s:db.ResolveDbObject(parts[0])
        if has_key(info, 'schema') 
          if info.type == 2 || info.type == 4
            " complete columns
            let result = s:Columns(info.schema, info.object, a:base, s:prefix)
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
      let info = s:db.ResolveDbObject(parts[0] . '.' . parts[1])
      if has_key(info, 'schema') 
        if info.type == 2 || info.type == 4
          " complete columns
          let result = s:Columns(info.schema, info.object, a:base, s:prefix)
        elseif info.type == 9 || info.type == 13
          " complete proc/func from the package/type
          let result = s:Submodules(info.schema, info.object, a:base)
        endif
      endif
    endif
    return result
  endif  
endfunction

" Get columns for the current position which might be comming from
" an alias specified in prefix. Returns a row list of columns. Some
" columns might be in the form of OBJECT.TABLE.*. These has to be further
" fetched using s:ExpandColumns(cols).
function s:ColumnsFromAlias(statement, alias, prefix)
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
          call extend(columns, s:Columns(info.schema, info.object, "", a:prefix))
        endif
      elseif len(parts) == 2
        " expand an object with a schema specified
        call extend(columns, s:Columns(toupper(parts[0]), toupper(parts[1]), "", a:prefix))
      endif
    else
      let columns += [col]
    endif
  endfor
  return columns
endfunction

" Get all columns which starts with the provided pattern
" from the given owner.table object.
function s:Columns(owner, table, pattern, prefix)
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

" Used to compare completion items in order to
" sort them
function! s:CompareEntries(i1, i2)
  return a:i1.word == a:i2.word ? 0 : a:i1.word > a:i2.word ? 1 : -1
endfunction

" Returns a list of keywords starting with the provided parameter
function s:SyntaxItems(start_with)
  let pattern = '^' . a:start_with
  let result = filter(copy(s:keywords), 'v:val.word =~? pattern')
  if s:utils.IsLower(a:start_with)
    let result = map(result, "{'word':tolower(v:val.word), 'dup':v:val.dup, 'kind':v:val.kind}")
  endif
  return result
endfunction

" Get parameter for the given module/submodule. If module is empty then
" the parameters for a standalone function/procedure is returned.
function s:ParamsFor(owner, module, submodule)
  if s:utils.IsLower(a:submodule)
    let arg = 'lower(argument_name)'
    let type = 'lower(data_type)'
  else
    let arg = 'argument_name'
    let type = 'data_type'
  endif
  let result = vorax#Exec(
        \ "set linesize 100\n" .
        \ "select " . arg . " || ' => ' || '::' || " . type . " || '::' || overload from all_arguments " . 
        \ "where owner='" . a:owner . "'" .
        \ (a:module != "" ? " and package_name ='" . a:module . "'" : "") .
        \ " and object_name ='" . toupper(a:submodule) . "'" .
        \ " and argument_name is not null " .
        \ " order by overload, position;" 
        \ , 0, "")
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
      let info = s:db.ResolveDbObject(fields[0])
      if has_key(info, 'schema') && info['schema'] != "" && info['object'] != ""
        let result = s:ParamsFor(info['schema'], '', info['object'])
      endif
    elseif len(fields) == 2
      " could be a package name + procedure or an owner + procedure
      let info = s:db.ResolveDbObject(fields[0])
      if has_key(info, 'schema') && info['schema'] != "" && info['object'] != ""
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
      let info = s:db.ResolveDbObject(fields[0] . '.' . fields[1])
      if has_key(info, 'schema') && info['schema'] != "" && info['object'] != ""
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


" Get user db objects which matches the provided pattern.
function s:SchemaObjects(schema, pattern)
  let obj = ""
  if s:utils.IsLower(a:pattern)
    let obj = "lower(object_name)"
  else
    let obj = "object_name"
  endif
  if a:schema == ""
    let schema = "user, 'PUBLIC'"
  else
    let schema = "'" . a:schema . "'"
  endif
  let result = vorax#Exec(
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
        \ "        and nvl(t2.object_type, t1.object_type) in ('TABLE', " .
        \ "                               'VIEW', " .
        \ "                               'SYNONYM', " .
        \ "                               'PROCEDURE', " .
        \ "                               'FUNCTION', " .
        \ "                               'PACKAGE', " .
        \ "                               'TYPE') " .
        \ " order by 1; "
        \ , 0, "")
  let items = []
  for row in result
    let fields = split(row, '::')
    if type(fields) != 3 || len(fields) != 2
      " unexpected result
      return []
    endif
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
    call add(items, {'word' : fields[0], 'kind' : kind, 'dup' : 1 })
  endfor
  return items
endfunction


" Get all procedures/functions for the provided plsql module
" (package/type). Only the submodules which matches the given
" pattern are returned
function s:Submodules(owner, module, pattern)
  let sm = ""
  if s:utils.IsLower(s:prefix)
    let sm = "lower(procedure_name)"
  else
    let sm = "procedure_name"
  endif
  let result = vorax#Exec(
        \ "set linesize 100\n" .
        \ "select " . sm . " from all_procedures " .
        \ "where owner='" . a:owner . "'" .
        \ " and object_name='" . a:module . "'" . 
        \ " and procedure_name like '".toupper(a:pattern)."%' " . 
        \ "order by subprogram_id;"
        \ , 0, "")
  return result
endfunction

