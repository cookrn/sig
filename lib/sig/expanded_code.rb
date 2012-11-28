require 'sig/template'

module Sig
  class ExpandedCode
    DEFAULT_FUNCTION    = '_'
    LAST_VAR            = 'h'
    SAFE_DIVISOR        = 15
    STANDARD_INVOCATION = "#{ DEFAULT_FUNCTION }.()"

    attr_reader \
      :art,
      :obfuscated_code

    def self.add_additional_functions_to( additional_function_count , code )
      code        = code.dup
      count       = additional_function_count
      first       = true
      var_pointer = LAST_VAR.dup # invalid to start since same as ending var in code

      while count > 0
        prev_func = first ? DEFAULT_FUNCTION : var_pointer
        new_func  = var_pointer.succ

        code << without_whitespace(
                  Template[ :additional_function ].result binding
                )
        code << "\n"

        count -= 1
        first  = false
        var_pointer.succ!
      end

      code << "#{ new_func }.()"
    end

    def self.add_standard_invocation_to( code )
      code.dup.tap { | code | code << STANDARD_INVOCATION }
    end

    def self.collapse( adjusted_code )
      adjusted_code.lines.to_a.map do | line |
        line.gsub /\r|\n/ , ''
      end.join ';'
    end

    def self.for( *args , &block )
      code = new *args , &block
      code.expand
      code
    end

    def self.size_with_standard_invocation( str )
      str.size + STANDARD_INVOCATION.size
    end

    def self.without_whitespace( str )
      str.gsub \
        /\s/,
        ''
    end

    def initialize( art , obfuscated_code )
      @art             = art
      @obfuscated_code = obfuscated_code
    end

    def additional_functions
      @_additional_functions ||=
        size_diff / SAFE_DIVISOR
    end

    def art_size
      @_art_size ||=
        self.class.without_whitespace( art ).size
    end

    def code_size
      @_code_size ||=
        self.class.size_with_standard_invocation obfuscated_code
    end

    def code_with_additional_functions
      @_code_with_additional_functions ||=
        self.class.add_additional_functions_to \
          additional_functions,
          obfuscated_code
    end

    def code_with_standard_invocation
      @_code_with_standard_invocation ||=
        self.class.add_standard_invocation_to obfuscated_code
    end

    def expand
      return @_expanded if @_expanded

      adjusted = if size_diff > 0
                   code_with_additional_functions
                 else
                   code_with_standard_invocation
                 end

      @_expanded = self.class.collapse adjusted
    end
    alias to_s    expand
    alias inspect expand

    def size_diff
      @_size_diff ||=
        art_size - code_size
    end
  end
end
