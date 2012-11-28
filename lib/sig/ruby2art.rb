require 'sig/tokenizer'

module Sig
  class Ruby2Art
    attr_reader \
      :art,
      :code

    def self.for( *args , &block )
      code_as_art = new *args , &block
      code_as_art.process
      code_as_art
    end

    def initialize( art , code )
      @art  = art
      @code = code
    end

    def process
      tokenizer
      # require 'pry'; binding.pry
      # return @_processed if @_processed

      # # tokenizer.each_token do | token |

      # # end

      # require 'pry'; binding.pry

      # # code_chars = code.chars.to_a
      # # @_processed = art.chars.to_a.map do | char |
      # #                 unless char =~ /\s/
      # #                   char = code_chars.shift
      # #                 end

      # #                 char
      # #               end.join
    end

    def tokenizer
      @_tokenizer ||= Tokenizer.for code
    end
  end
end
