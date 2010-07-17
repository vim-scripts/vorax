#!/usr/bin/env ruby
#
# PlsqlBlock.g
# 
# Generated using ANTLR version: 3.2.1-SNAPSHOT Jun 18, 2010 05:38:11
# Ruby runtime library version: 1.7.4
# Input grammar file: PlsqlBlock.g
# Generated at: 2010-07-14 17:01:29
# 

# ~~~> start load path setup
this_directory = File.expand_path( File.dirname( __FILE__ ) )
$LOAD_PATH.unshift( this_directory ) unless $LOAD_PATH.include?( this_directory )

antlr_load_failed = proc do
  load_path = $LOAD_PATH.map { |dir| '  - ' << dir }.join( $/ )
  raise LoadError, <<-END.strip!
  
Failed to load the ANTLR3 runtime library (version 1.7.4):

Ensure the library has been installed on your system and is available
on the load path. If rubygems is available on your system, this can
be done with the command:
  
  gem install antlr3

Current load path:
#{ load_path }

  END
end

defined?( ANTLR3 ) or begin
  
  # 1: try to load the ruby antlr3 runtime library from the system path
  require 'antlr3'
  
rescue LoadError
  
  # 2: try to load rubygems if it isn't already loaded
  defined?( Gem ) or begin
    require 'rubygems'
  rescue LoadError
    antlr_load_failed.call
  end
  
  # 3: try to activate the antlr3 gem
  begin
    Gem.activate( 'antlr3', '~> 1.7.4' )
  rescue Gem::LoadError
    antlr_load_failed.call
  end
  
  require 'antlr3'
  
end
# <~~~ end load path setup


module PlsqlBlock
  # TokenData defines all of the token type integer values
  # as constants, which will be included in all 
  # ANTLR-generated recognizers.
  const_defined?( :TokenData ) or TokenData = ANTLR3::TokenScheme.new

  module TokenData

    # define the token constants
    define_tokens( :ML_COMMENT => 10, :WS => 4, :OBJECT_TYPE => 5, :OBJECT => 6, 
                    :DOUBLEQUOTED_STRING => 12, :SL_COMMENT => 9, :QUOTED_STRING => 8, 
                    :ID => 11, :EOF => -1, :START_MODULE => 7 )
    
  end


  class Lexer < ANTLR3::Lexer
    @grammar_home = PlsqlBlock
    include TokenData
    include ANTLR3::FilterMode

    
    begin
      generated_using( "PlsqlBlock.g", "3.2.1-SNAPSHOT Jun 18, 2010 05:38:11", "1.7.4" )
    rescue NoMethodError => error
      # ignore
    end
    
    RULE_NAMES   = [ "START_MODULE", "QUOTED_STRING", "SL_COMMENT", "ML_COMMENT", 
                      "WS", "OBJECT", "OBJECT_TYPE", "ID", "DOUBLEQUOTED_STRING" ].freeze
    RULE_METHODS = [ :start_module!, :quoted_string!, :sl_comment!, :ml_comment!, 
                      :ws!, :object!, :object_type!, :id!, :doublequoted_string! ].freeze

    
    def initialize( input=nil, options = {} )
      super( input, options )
      # - - - - - - begin action @lexer::init - - - - - -
      # PlsqlBlock.g


        @oracle_modules = []

      # - - - - - - end action @lexer::init - - - - - - -

    end
    
    # - - - - - - begin action @lexer::members - - - - - -
    # PlsqlBlock.g



      attr_reader :oracle_modules


    # - - - - - - end action @lexer::members - - - - - - -

    
    # - - - - - - - - - - - lexer rules - - - - - - - - - - - -
    # lexer rule start_module! (START_MODULE)
    # (in PlsqlBlock.g)
    def start_module!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 1 )

      type = START_MODULE
      channel = ANTLR3::DEFAULT_CHANNEL
      # - - - - label initialization - - - -
      tk = nil
      __OBJECT_TYPE1__ = nil


      
      # - - - - main rule block - - - -
      # at line 19:5: tk= 'CREATE' ( WS 'OR' WS 'REPLACE' )? WS OBJECT_TYPE OBJECT
      tk_start = self.character_index
      match( "CREATE" )
      tk = create_token do |t|
        t.input   = @input
        t.type    = ANTLR3::INVALID_TOKEN_TYPE
        t.channel = ANTLR3::DEFAULT_CHANNEL
        t.start   = tk_start
        t.stop    = character_index - 1
      end
      # at line 19:17: ( WS 'OR' WS 'REPLACE' )?
      alt_1 = 2
      alt_1 = @dfa1.predict( @input )
      case alt_1
      when 1
        # at line 19:18: WS 'OR' WS 'REPLACE'
        ws!
        match( "OR" )
        ws!
        match( "REPLACE" )

      end
      ws!
      __OBJECT_TYPE1___start_62 = self.character_index
      object_type!
      __OBJECT_TYPE1__ = create_token do |t|
        t.input   = @input
        t.type    = ANTLR3::INVALID_TOKEN_TYPE
        t.channel = ANTLR3::DEFAULT_CHANNEL
        t.start   = __OBJECT_TYPE1___start_62
        t.stop    = self.character_index - 1
      end
      # syntactic predicate action gate test
      if @state.backtracking == 1
        # --> action
         @object_type = __OBJECT_TYPE1__.text if __OBJECT_TYPE1__
        # <-- action
      end
      object!
      # syntactic predicate action gate test
      if @state.backtracking == 1
        # --> action

            @object_name.gsub!(/"/, '') if @object_name
            @owner.gsub!(/"/, '') if @owner
            @object_type.strip! if @object_type
            pos = tk.start
            lines = self.input.data[ 0 .. pos ]
            @oracle_modules << { :object => @object_name, :type => @object_type, :owner => @owner, :start_line => lines.split(/\n/).length }
            @object_name = nil
            @object_type = nil
            @owner = nil
          
        # <-- action
      end

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 1 )

    end

    # lexer rule quoted_string! (QUOTED_STRING)
    # (in PlsqlBlock.g)
    def quoted_string!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 2 )

      type = QUOTED_STRING
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 34:5: ( 'n' )? '\\'' ( '\\'\\'' | ~ ( '\\'' ) )* '\\''
      # at line 34:5: ( 'n' )?
      alt_2 = 2
      look_2_0 = @input.peek( 1 )

      if ( look_2_0 == ?n )
        alt_2 = 1
      end
      case alt_2
      when 1
        # at line 34:7: 'n'
        match( ?n )

      end
      match( ?\' )
      # at line 34:19: ( '\\'\\'' | ~ ( '\\'' ) )*
      while true # decision 3
        alt_3 = 3
        look_3_0 = @input.peek( 1 )

        if ( look_3_0 == ?\' )
          look_3_1 = @input.peek( 2 )

          if ( look_3_1 == ?\' )
            alt_3 = 1

          end
        elsif ( look_3_0.between?( 0x0000, ?& ) || look_3_0.between?( ?(, 0xFFFF ) )
          alt_3 = 2

        end
        case alt_3
        when 1
          # at line 34:21: '\\'\\''
          match( "''" )

        when 2
          # at line 34:30: ~ ( '\\'' )
          if @input.peek( 1 ).between?( 0x0000, ?& ) || @input.peek( 1 ).between?( ?(, 0x00FF )
            @input.consume
          else
            @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

            mse = MismatchedSet( nil )
            recover mse
            raise mse
          end



        else
          break # out of loop for decision 3
        end
      end # loop for decision 3
      match( ?\' )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 2 )

    end

    # lexer rule sl_comment! (SL_COMMENT)
    # (in PlsqlBlock.g)
    def sl_comment!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 3 )

      type = SL_COMMENT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 38:5: '--' (~ ( '\\n' | '\\r' ) )* ( '\\r' )? '\\n'
      match( "--" )
      # at line 38:10: (~ ( '\\n' | '\\r' ) )*
      while true # decision 4
        alt_4 = 2
        look_4_0 = @input.peek( 1 )

        if ( look_4_0.between?( 0x0000, ?\t ) || look_4_0.between?( 0x000B, ?\f ) || look_4_0.between?( 0x000E, 0xFFFF ) )
          alt_4 = 1

        end
        case alt_4
        when 1
          # at line 38:10: ~ ( '\\n' | '\\r' )
          if @input.peek( 1 ).between?( 0x0000, ?\t ) || @input.peek( 1 ).between?( 0x000B, ?\f ) || @input.peek( 1 ).between?( 0x000E, 0x00FF )
            @input.consume
          else
            @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

            mse = MismatchedSet( nil )
            recover mse
            raise mse
          end



        else
          break # out of loop for decision 4
        end
      end # loop for decision 4
      # at line 38:24: ( '\\r' )?
      alt_5 = 2
      look_5_0 = @input.peek( 1 )

      if ( look_5_0 == ?\r )
        alt_5 = 1
      end
      case alt_5
      when 1
        # at line 38:24: '\\r'
        match( ?\r )

      end
      match( ?\n )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 3 )

    end

    # lexer rule ml_comment! (ML_COMMENT)
    # (in PlsqlBlock.g)
    def ml_comment!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 4 )

      type = ML_COMMENT
      channel = ANTLR3::DEFAULT_CHANNEL

      
      # - - - - main rule block - - - -
      # at line 42:5: '/*' ( options {greedy=false; } : . )* '*/'
      match( "/*" )
      # at line 42:10: ( options {greedy=false; } : . )*
      while true # decision 6
        alt_6 = 2
        look_6_0 = @input.peek( 1 )

        if ( look_6_0 == ?* )
          look_6_1 = @input.peek( 2 )

          if ( look_6_1 == ?/ )
            alt_6 = 2
          elsif ( look_6_1.between?( 0x0000, ?. ) || look_6_1.between?( ?0, 0xFFFF ) )
            alt_6 = 1

          end
        elsif ( look_6_0.between?( 0x0000, ?) ) || look_6_0.between?( ?+, 0xFFFF ) )
          alt_6 = 1

        end
        case alt_6
        when 1
          # at line 42:38: .
          match_any

        else
          break # out of loop for decision 6
        end
      end # loop for decision 6
      match( "*/" )

      
      @state.type = type
      @state.channel = channel

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 4 )

    end

    # lexer rule ws! (WS)
    # (in PlsqlBlock.g)
    def ws!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 5 )

      
      # - - - - main rule block - - - -
      # at line 47:5: ( ' ' | '\\t' | '\\n' )+
      # at file 47:5: ( ' ' | '\\t' | '\\n' )+
      match_count_7 = 0
      while true
        alt_7 = 2
        look_7_0 = @input.peek( 1 )

        if ( look_7_0.between?( ?\t, ?\n ) || look_7_0 == ?\s )
          alt_7 = 1

        end
        case alt_7
        when 1
          # at line 
          if @input.peek( 1 ).between?( ?\t, ?\n ) || @input.peek(1) == ?\s
            @input.consume
          else
            @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

            mse = MismatchedSet( nil )
            recover mse
            raise mse
          end



        else
          match_count_7 > 0 and break
          @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

          eee = EarlyExit(7)


          raise eee
        end
        match_count_7 += 1
      end


    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 5 )

    end

    # lexer rule object! (OBJECT)
    # (in PlsqlBlock.g)
    def object!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 6 )
      # - - - - label initialization - - - -
      owner = nil
      object = nil


      
      # - - - - main rule block - - - -
      # at line 52:5: (owner= ID '.' )? object= ID
      # at line 52:5: (owner= ID '.' )?
      alt_8 = 2
      alt_8 = @dfa8.predict( @input )
      case alt_8
      when 1
        # at line 52:6: owner= ID '.'
        owner_start_213 = self.character_index
        id!
        owner = create_token do |t|
          t.input   = @input
          t.type    = ANTLR3::INVALID_TOKEN_TYPE
          t.channel = ANTLR3::DEFAULT_CHANNEL
          t.start   = owner_start_213
          t.stop    = self.character_index - 1
        end
        # syntactic predicate action gate test
        if @state.backtracking == 1
          # --> action
           @owner = owner.text if owner 
          # <-- action
        end
        match( ?. )

      end
      object_start_223 = self.character_index
      id!
      object = create_token do |t|
        t.input   = @input
        t.type    = ANTLR3::INVALID_TOKEN_TYPE
        t.channel = ANTLR3::DEFAULT_CHANNEL
        t.start   = object_start_223
        t.stop    = self.character_index - 1
      end
      # syntactic predicate action gate test
      if @state.backtracking == 1
        # --> action
         @object_name = object.text if object 
        # <-- action
      end

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 6 )

    end

    # lexer rule object_type! (OBJECT_TYPE)
    # (in PlsqlBlock.g)
    def object_type!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 7 )

      
      # - - - - main rule block - - - -
      # at line 57:3: ( 'PROCEDURE' WS | 'FUNCTION' WS | 'TRIGGER' WS | 'TYPE' WS ( 'BODY' WS )? | 'PACKAGE' WS ( 'BODY' WS )? )
      alt_11 = 5
      case look_11 = @input.peek( 1 )
      when ?P then look_11_1 = @input.peek( 2 )

      if ( look_11_1 == ?R )
        alt_11 = 1
      elsif ( look_11_1 == ?A )
        alt_11 = 5
      else
        @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

        raise NoViableAlternative( "", 11, 1 )
      end
      when ?F then alt_11 = 2
      when ?T then look_11_3 = @input.peek( 2 )

      if ( look_11_3 == ?R )
        alt_11 = 3
      elsif ( look_11_3 == ?Y )
        alt_11 = 4
      else
        @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

        raise NoViableAlternative( "", 11, 3 )
      end
      else
        @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

        raise NoViableAlternative( "", 11, 0 )
      end
      case alt_11
      when 1
        # at line 57:5: 'PROCEDURE' WS
        match( "PROCEDURE" )
        ws!

      when 2
        # at line 58:5: 'FUNCTION' WS
        match( "FUNCTION" )
        ws!

      when 3
        # at line 59:5: 'TRIGGER' WS
        match( "TRIGGER" )
        ws!

      when 4
        # at line 60:5: 'TYPE' WS ( 'BODY' WS )?
        match( "TYPE" )
        ws!
        # at line 60:15: ( 'BODY' WS )?
        alt_9 = 2
        look_9_0 = @input.peek( 1 )

        if ( look_9_0 == ?B )
          alt_9 = 1
        end
        case alt_9
        when 1
          # at line 60:16: 'BODY' WS
          match( "BODY" )
          ws!

        end

      when 5
        # at line 61:5: 'PACKAGE' WS ( 'BODY' WS )?
        match( "PACKAGE" )
        ws!
        # at line 61:18: ( 'BODY' WS )?
        alt_10 = 2
        look_10_0 = @input.peek( 1 )

        if ( look_10_0 == ?B )
          alt_10 = 1
        end
        case alt_10
        when 1
          # at line 61:19: 'BODY' WS
          match( "BODY" )
          ws!

        end

      end
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 7 )

    end

    # lexer rule id! (ID)
    # (in PlsqlBlock.g)
    def id!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 8 )

      
      # - - - - main rule block - - - -
      # at line 66:5: ( 'A' .. 'Z' ( 'A' .. 'Z' | '0' .. '9' | '_' | '$' | '#' )* | DOUBLEQUOTED_STRING )
      alt_13 = 2
      look_13_0 = @input.peek( 1 )

      if ( look_13_0.between?( ?A, ?Z ) )
        alt_13 = 1
      elsif ( look_13_0 == ?" )
        alt_13 = 2
      else
        @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

        raise NoViableAlternative( "", 13, 0 )
      end
      case alt_13
      when 1
        # at line 66:7: 'A' .. 'Z' ( 'A' .. 'Z' | '0' .. '9' | '_' | '$' | '#' )*
        match_range( ?A, ?Z )
        # at line 66:18: ( 'A' .. 'Z' | '0' .. '9' | '_' | '$' | '#' )*
        while true # decision 12
          alt_12 = 2
          look_12_0 = @input.peek( 1 )

          if ( look_12_0.between?( ?#, ?$ ) || look_12_0.between?( ?0, ?9 ) || look_12_0.between?( ?A, ?Z ) || look_12_0 == ?_ )
            alt_12 = 1

          end
          case alt_12
          when 1
            # at line 
            if @input.peek( 1 ).between?( ?#, ?$ ) || @input.peek( 1 ).between?( ?0, ?9 ) || @input.peek( 1 ).between?( ?A, ?Z ) || @input.peek(1) == ?_
              @input.consume
            else
              @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

              mse = MismatchedSet( nil )
              recover mse
              raise mse
            end



          else
            break # out of loop for decision 12
          end
        end # loop for decision 12

      when 2
        # at line 67:7: DOUBLEQUOTED_STRING
        doublequoted_string!

      end
    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 8 )

    end

    # lexer rule doublequoted_string! (DOUBLEQUOTED_STRING)
    # (in PlsqlBlock.g)
    def doublequoted_string!
      # -> uncomment the next line to manually enable rule tracing
      # trace_in( __method__, 9 )

      
      # - - - - main rule block - - - -
      # at line 72:5: '\"' (~ ( '\"' ) )* '\"'
      match( ?" )
      # at line 72:9: (~ ( '\"' ) )*
      while true # decision 14
        alt_14 = 2
        look_14_0 = @input.peek( 1 )

        if ( look_14_0.between?( 0x0000, ?! ) || look_14_0.between?( ?#, 0xFFFF ) )
          alt_14 = 1

        end
        case alt_14
        when 1
          # at line 72:11: ~ ( '\"' )
          if @input.peek( 1 ).between?( 0x0000, ?! ) || @input.peek( 1 ).between?( ?#, 0x00FF )
            @input.consume
          else
            @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

            mse = MismatchedSet( nil )
            recover mse
            raise mse
          end



        else
          break # out of loop for decision 14
        end
      end # loop for decision 14
      match( ?" )

    ensure
      # -> uncomment the next line to manually enable rule tracing
      # trace_out( __method__, 9 )

    end

    # main rule used to study the input at the current position,
    # and choose the proper lexer rule to call in order to
    # fetch the next token
    # 
    # usually, you don't make direct calls to this method,
    # but instead use the next_token method, which will
    # build and emit the actual next token
    def token!
      # at line 1:39: ( START_MODULE | QUOTED_STRING | SL_COMMENT | ML_COMMENT )
      alt_15 = 4
      case look_15 = @input.peek( 1 )
      when ?C then alt_15 = 1
      when ?\', ?n then alt_15 = 2
      when ?- then alt_15 = 3
      when ?/ then alt_15 = 4
      else
        @state.backtracking > 0 and raise( ANTLR3::Error::BacktrackingFailed )

        raise NoViableAlternative( "", 15, 0 )
      end
      case alt_15
      when 1
        # at line 1:41: START_MODULE
        start_module!

      when 2
        # at line 1:54: QUOTED_STRING
        quoted_string!

      when 3
        # at line 1:68: SL_COMMENT
        sl_comment!

      when 4
        # at line 1:79: ML_COMMENT
        ml_comment!

      end
    end

    
    # - - - - - - - - - - DFA definitions - - - - - - - - - - -
    class DFA1 < ANTLR3::DFA
      EOT = unpack( 4, -1 )
      EOF = unpack( 4, -1 )
      MIN = unpack( 2, 9, 2, -1 )
      MAX = unpack( 1, 32, 1, 84, 2, -1 )
      ACCEPT = unpack( 2, -1, 1, 1, 1, 2 )
      SPECIAL = unpack( 4, -1 )
      TRANSITION = [
        unpack( 2, 1, 21, -1, 1, 1 ),
        unpack( 2, 1, 21, -1, 1, 1, 37, -1, 1, 3, 8, -1, 1, 2, 1, 3, 3, 
                  -1, 1, 3 ),
        unpack(  ),
        unpack(  )
      ].freeze
      
      ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
        if a > 0 and z < 0
          MAX[ i ] %= 0x10000
        end
      end
      
      @decision = 1
      

      def description
        <<-'__dfa_description__'.strip!
          19:17: ( WS 'OR' WS 'REPLACE' )?
        __dfa_description__
      end
    end
    class DFA8 < ANTLR3::DFA
      EOT = unpack( 1, -1, 1, 4, 1, -1, 1, 4, 3, -1, 1, 4 )
      EOF = unpack( 8, -1 )
      MIN = unpack( 1, 34, 1, 35, 1, 0, 1, 35, 2, -1, 1, 0, 1, 46 )
      MAX = unpack( 1, 90, 1, 95, 1, -1, 1, 95, 2, -1, 1, -1, 1, 46 )
      ACCEPT = unpack( 4, -1, 1, 2, 1, 1, 2, -1 )
      SPECIAL = unpack( 2, -1, 1, 1, 3, -1, 1, 0, 1, -1 )
      TRANSITION = [
        unpack( 1, 2, 30, -1, 26, 1 ),
        unpack( 2, 3, 9, -1, 1, 5, 1, -1, 10, 3, 7, -1, 26, 3, 4, -1, 
                  1, 3 ),
        unpack( 34, 6, 1, 7, 65501, 6 ),
        unpack( 2, 3, 9, -1, 1, 5, 1, -1, 10, 3, 7, -1, 26, 3, 4, -1, 
                  1, 3 ),
        unpack(  ),
        unpack(  ),
        unpack( 34, 6, 1, 7, 65501, 6 ),
        unpack( 1, 5 )
      ].freeze
      
      ( 0 ... MIN.length ).zip( MIN, MAX ) do | i, a, z |
        if a > 0 and z < 0
          MAX[ i ] %= 0x10000
        end
      end
      
      @decision = 8
      

      def description
        <<-'__dfa_description__'.strip!
          52:5: (owner= ID '.' )?
        __dfa_description__
      end
    end

    
    private
    
    def initialize_dfas
      super rescue nil
      @dfa1 = DFA1.new( self, 1 )
      @dfa8 = DFA8.new( self, 8 ) do |s|
        case s
        when 0
          look_8_6 = @input.peek
          s = -1
          if ( look_8_6 == ?" )
            s = 7
          elsif ( look_8_6.between?( 0x0000, ?! ) || look_8_6.between?( ?#, 0xFFFF ) )
            s = 6
          end

        when 1
          look_8_2 = @input.peek
          s = -1
          if ( look_8_2.between?( 0x0000, ?! ) || look_8_2.between?( ?#, 0xFFFF ) )
            s = 6
          elsif ( look_8_2 == ?" )
            s = 7
          end

        end
        
        if s < 0
          @state.backtracking > 0 and raise ANTLR3::Error::BacktrackingFailed
          nva = ANTLR3::Error::NoViableAlternative.new( @dfa8.description, 8, s, input )
          @dfa8.error( nva )
          raise nva
        end
        
        s
      end

    end
  end # class Lexer < ANTLR3::Lexer

  at_exit { Lexer.main( ARGV ) } if __FILE__ == $0
end

