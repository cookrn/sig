require 'sig/template'

module Sig
  class ObfuscatedCode
    DEFAULT_CODE = 'puts File.read $0'

    attr_reader \
      :characters,
      :original_code

    def self.for( *args , &block )
      code = new *args , &block
      code.obfuscate
      code
    end

    def self.obfuscate( code )
      # Grab the characters
      chars = code.chars.to_a

      # Shuffle them up
      shuffled_chars = chars.shuffle

      # Map the index of the shuffled chars to the char
      shuffled_map = chars.inject({}) do | memo , char |
        memo[ shuffled_chars.index char ] = char
        memo
      end

      # Then shuffle up the hash
      shuffled_again = shuffled_map.keys.shuffle.inject({}) do | memo , index |
        memo[ index ] = shuffled_map[ index ]
        memo
      end

      # Grab the funky indices of the shuffled chars
      coded_indices = chars.map{ | char | shuffled_again.invert[ char ] }

      # Render the template
      Template[ :obfuscated_code ].result binding
    end

    def initialize( original_code = nil )
      @original_code = ( original_code or DEFAULT_CODE )
    end

    def obfuscate
      @_obfuscated ||= self.class.obfuscate original_code
    end
    alias to_s    obfuscate
    alias inspect obfuscate
  end
end
