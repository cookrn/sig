require 'rubygems'
require 'bundler/setup'

####
#
# BREAK up the code into reasonable segments
#
  code = File.read 'f.rb'
  code_chars = code.chars.to_a

  segments = []

  class Char < Struct.new( :char )
    def needs?( char )
      false
    end

    def to_s
      char
    end
  end

  class VarChar < Char
    def needs?( other_char )
      other_char =~ /[\*a-zA-Z\._]/
    end
  end

  class Operator < Char
    def needs?( other_char )
      if char =~ /[=-]/ and other_char == '>'
        true
      else
        false
      end
    end
  end

  class Space < Char
  end

  class Sym < Char
  end

  class Num < Char
  end

  class Quote < Char
    def needs?( other_char )
      string_chars = char.chars.to_a
      starter = string_chars.shift
      return false if string_chars.last == starter
      true
    end
  end

  class Terminator < Char
  end

  code_chars.each do | char |
    previous_segment = segments.last
    case
      when previous_segment.is_a?( Quote ) && previous_segment.needs?( char )
        previous_segment.char << char
      when char =~ /[\*a-zA-Z\._]/
        if previous_segment and previous_segment.needs?( char )
          previous_segment.char << char
        else
          segments << VarChar.new( char )
        end
      when char == ' '
        segments << Space.new( char )
      when char == ';'
        segments << Terminator.new( char )
      when char =~ /[=-]/
        segments << Operator.new( char )
      when char =~ /["']/
        if previous_segment.is_a? Quote
          previous_segment.char << char
        else
          segments << Quote.new( char )
        end
      when char =~ /[\{\},\(\)\|\[\]]/
        segments << Sym.new( char )
      when char =~ /[0-9]/
        if previous_segment.is_a?( Num )
          previous_segment.char << char
        else
          segments << Num.new( char )
        end
      when char == '>'
        if previous_segment.needs? '>'
          previous_segment.char << char
        else
          segments << Sym.new( char )
        end
      else
        require 'pry'; binding.pry
        raise
    end
  end
#
#
#
####

# Check!
joined_code = segments.map( &:to_s ).join
raise unless joined_code == code

####
#
# MAP the segmented code onto ASCII art
#
  require 'sig/art'
  art = Sig::Art.for 'ART'
  art_chars = art.to_s.chars.to_a

  code_art = []
  current_segment = segments.shift
  current_segment_length = current_segment.length
  next_for = false

  art_chars.each_with_index do | char , i |
    if next_for and next_for > 0
      next_for -= 1
      next
    end

    if char =~ /\s/
      code_art << char
      next
    end

    end_index = i + current_segment_length - 1
    art_segment = art_chars[ i .. end_index ]
    next if art_segment.grep( /\s/ ).any?

    code_art << current_segment.to_s
    next_for = current_segment_length
    current_segment = segments.shift
    break unless current_segment
    current_segment_length = current_segment.length
  end
#
#
#
####

artsy_code = code_art.join

require 'pry'; binding.pry
