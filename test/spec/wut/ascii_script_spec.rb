require 'test_helper'

describe Wut::AsciiScript do
  it 'is initialized with a string' do
    proc do
      Wut::AsciiScript.new
    end.must_raise ArgumentError
  end

  it 'provides access to the passed string later' do
    Wut::AsciiScript.new( 'word' ).must_respond_to :word
  end
end
