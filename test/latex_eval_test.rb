require 'minitest/autorun'
require_relative './../lib/latex_eval.rb'

class TestLatexEval < Minitest::Test
  def test_it_all
    latex = '\frac{1}{2}\cdot3\xi+4' 
    assert_equal LatexEval.eval(latex, {xi: 2}), 7
  end

  def test_postfix_notation
    latex = '1+3*2' 
    assert_equal LatexEval.postfix_notation(latex), [1, 3, 2, :multiply, :add]
  end
end
