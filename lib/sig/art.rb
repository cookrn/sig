require 'artii'

module Sig
  class Art
    FONT = 'doh'

    attr_reader :word

    def self.raw_art_for( word )
      Artii::Base.new( :font => FONT ).asciify word
    end

    def self.for( *args , &block )
      art = new *args , &block
      art.generate
      art
    end

    def self.strip_empty_lines( str )
      new_str = ''
      str.each_line do | line |
        new_str << line unless line.gsub( /\s/ , '' ).empty?
      end
      new_str
    end

    def initialize( word )
      @word = word
    end

    def generate
      @_generated ||= self.class.strip_empty_lines raw
    end
    alias to_s    generate
    alias inspect generate

    def raw
      @_raw ||= self.class.raw_art_for word
    end
  end
end
