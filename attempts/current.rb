require 'bundler'
Bundler.setup

# external libs
require 'artii'
require 'erb'
require 'pry'

# word to run
word = ARGV.first

# font to use
font = 'doh'

# word turned in to ascii art
art_for_word = Artii::Base.new( :font => font ).asciify word

# remove empty lines
tmp = ''
art_for_word.each_line do | line |
  tmp << line unless line.gsub( /\s/ , '' ).empty?
end
art_for_word = tmp

# code that we're obfuscating
code_to_be_obfuscated = 'puts File.read $0'
code_chars = code_to_be_obfuscated.chars.to_a
shuffled_chars = code_chars.shuffle

# Map the index of the shuffled chars to the char
shuffled_map = code_chars.inject({}) do | memo , char |
  memo[ shuffled_chars.index char ] = char
  memo
end

# Then shuffle up the hash
shuffled_again = shuffled_map.keys.shuffle.inject({}) do | memo , index |
  memo[ index ] = shuffled_map[ index ]
  memo
end

# Grab the funky indices of the shuffled chars
coded_indices = code_chars.map{ | char | shuffled_again.invert[ char ] }

template_1 = <<___
a=<%= shuffled_again.inspect.gsub(/, /,',') %>
b=->(*c){c*''}
d=->(e){eval e}
f=->(*g){g.map{|h|a[h]}}
_=->{d[b[f[*<%= coded_indices.inspect.gsub(/\s/,'') %>]]]}
___

obfuscated_code = ERB.new( template_1 ).result binding

art_size = art_for_word.gsub(/\s/,'').size

default_function = '_'
standard_invocation = "#{ default_function }.()"
code_size = obfuscated_code.size + standard_invocation.size

size_diff = art_size - code_size
adjusted = if size_diff > 0
             safe_divisor = 15

             code        = obfuscated_code.dup
             count       = size_diff / safe_divisor
             first       = true
             var_pointer = 'h' # invalid to start since same as ending var in code

             template_2 = <<___
<%= new_func %>=->{<%= prev_func %>[]}
___

             while count > 0
               prev_func = first ? default_function : var_pointer
               new_func  = var_pointer.succ

               code << ERB.new( template_2 ).result( binding ).gsub("\n",'')
               code << "\n"

               count -= 1
               first  = false
               var_pointer.succ!
             end

             code << "#{ new_func }.()"
             code
           else
             obfuscated_code.dup.tap { | code | code << standard_invocation }
           end

ready_code = adjusted.lines.to_a.map do | line |
               line.gsub /\r|\n/ , ''
             end.join ';'

binding.pry
