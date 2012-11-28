require 'test_helper'

class AsciiScriptTest < MiniTest::Unit::TestCase
  def test_accepts_a_string_argument
    word = 'word'
    script = Wut::AsciiScript.new word

    assert_equal \
      word,
      script.word
  end

  def test_coerces_argument_to_string
    script = Wut::AsciiScript.new 1

    assert_equal \
      '1',
      script.word
  end
end
