require 'sig/ruby2shorthand'

class ArtsyCode # < Ruby2Shorthand
  attr_reader :art

  # def initialize( art )
  #   @art = art.to_s
  #   super()
  # end

  # def process( exp )
  #   puts '==================================='
  #   puts "EXP: #{ exp.inspect }"
  #   result = super
  #   puts "RESULT: #{ result.inspect }"
  #   puts '==================================='
  #   puts
  #   result
  # end

  def initialize( art )
    @art = art
  end

  def process!
  end
end
