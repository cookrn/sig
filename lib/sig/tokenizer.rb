require 'sig/tokenizer/token'

module Sig
  class Tokenizer
    attr_reader \
      :code,
      :tokens

    def self.for( *args , &block )
      tokenizer = new *args , &block
      tokenizer.process
      tokenizer
    end

    def initialize( code )
      @code   = code
      @tokens = []
    end

    def add_char_to_existing_token( char , token )
      token << char
      token
    end

    def each_token( &block )
      @tokens.each &block
    end

    def new_token_for( char )
      token = Token.new( char )
      @tokens << token
      token
    end

    def process
      code.chars.to_a.each do | char |
        @_current_token = process_char \
                           @_current_token,
                           char
      end
    end

    def process_char( token , char )
      if token and token.open? && token.needs?( char )
        add_char_to_existing_token \
          char,
          token
      else
        new_token_for char
      end
    end
  end
end
