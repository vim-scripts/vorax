lexer grammar PlsqlBlock;

options {
  language=Ruby;
  filter=true;
}

@members {

  attr_reader :oracle_modules

}

@init {
  @oracle_modules = []
}

START_MODULE
  : tk='CREATE' (WS 'OR' WS 'REPLACE')? WS OBJECT_TYPE { @object_type = $OBJECT_TYPE.text if $OBJECT_TYPE} OBJECT
  {
    @object_name.gsub!(/"/, '') if @object_name
    @owner.gsub!(/"/, '') if @owner
    @object_type.strip! if @object_type
    pos = $tk.start
    lines = self.input.data[ 0 .. pos ]
    @oracle_modules << { :object => @object_name, :type => @object_type, :owner => @owner, :start_line => lines.split(/\n/).length }
    @object_name = nil
    @object_type = nil
    @owner = nil
  }
  ;
  
QUOTED_STRING
  : ( 'n' )? '\'' ( '\'\'' | ~('\'') )* '\''
  ;
  
SL_COMMENT
  : '--' ~('\n'|'\r')* '\r'? '\n' 
  ;
  
ML_COMMENT
  : '/*' ( options {greedy=false;} : . )* '*/' 
  ;

fragment
WS  
  : (' '|'\t'|'\n')+
  ;

fragment
OBJECT
  : (owner=ID { @owner = $owner.text if $owner } '.')? object=ID { @object_name = $object.text if $object }
  ;

fragment
OBJECT_TYPE
  : 'PROCEDURE' WS
  | 'FUNCTION' WS
  | 'TRIGGER' WS
  | 'TYPE' WS ('BODY' WS)? 
  | 'PACKAGE' WS ('BODY' WS)?
  ;

fragment
ID 
    : 'A' .. 'Z' ( 'A' .. 'Z' | '0' .. '9' | '_' | '$' | '#' )*
    | DOUBLEQUOTED_STRING
    ;

fragment
DOUBLEQUOTED_STRING
  : '"' ( ~('"') )* '"'
  ;
