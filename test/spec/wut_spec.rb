require 'test_helper'

describe Wut do
  it 'generates output' do
    Wut.must_respond_to :generate
  end

  it 'generates output given a string' do
    Wut.method( :generate ).arity.must_equal 1
  end
end
