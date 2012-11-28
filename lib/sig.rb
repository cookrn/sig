require 'sig/generator'

module Sig
  def self.generate( word )
    Generator.new( word ).run
  end

  def self.generate!( word )
    puts generate( word ).to_s
  end
end
