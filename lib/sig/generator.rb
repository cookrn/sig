require 'ruby_parser'

require 'sig/art'
require 'sig/expanded_code'
require 'sig/obfuscated_code'
require 'sig/ruby2art'

module Sig
  class Generator
    attr_reader \
      :art,
      :artsy_code,
      :obfuscated_code,
      :word

    def initialize( word )
      @word = word
    end

    def run
      @art             = Art.for word
      @obfuscated_code = ObfuscatedCode.for
      @expanded_code   = ExpandedCode.for \
                           @art.to_s,
                           @obfuscated_code.to_s
      @artsy_code      = Ruby2Art.for \
                           @art.to_s,
                           @expanded_code.to_s

      require 'pry'; binding.pry

      self
    end
  end
end
