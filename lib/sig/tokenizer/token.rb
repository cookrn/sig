require 'forwardable'

module Sig
  class Tokenizer
    class Token
      attr_reader :chars

      extend Forwardable
      def_delegator \
        :@chars,
        :<<

      FINISHERS = {
        /=|\{|\(|,|;|\}/ => /./,
        /\s/        => /\S/,
        /\d/        => /\D/,
        /\w/        => /=|,|;|\[/
      }

      def initialize( chars )
        @chars = chars
      end

      def chars_ary
        @chars.chars.to_a
      end

      def complete?
        if chars_ary.size > 1
          case char = chars_ary.last
          when '"' , "'"
            starts_with? char
          when '>'
            starts_with? %w(- =)
          else
            finisher_matches? char
          end
        else
          false
        end
      end

      def finisher
        return @_finisher if @_finisher

        char = chars_ary.first
        f    = FINISHERS[ char ]

        unless f
          key = FINISHERS.keys.detect { | key | key =~ char rescue next }
          f   = FINISHERS[ key ]
        end

        @_finisher = f
      end

      def finisher_matches?( char )
        if finisher.is_a? Regexp
          char =~ finisher
        else
          char == finisher
        end
      end

      def needs?( char )
        case char
        when '"' , "'"
          starts_with? char
        when '>'
          starts_with? %w(- =)
        else
          !finisher_matches? char
        end
      end

      def open?
        !complete?
      end

      def starts_with?( chars )
        chars = [ chars ] unless chars.is_a?( Array )
        chars.include? chars_ary.first
      end
    end
  end
end
