require 'minitest/autorun'
require_relative './../lib/latex_eval.rb'

class TestLatexEval < Minitest::Test
  def test_it_all
    latex = '\frac{1}{2}\cdot3\xi+4' 
    assert_equal LatexEval.parse_latex(latex, {xi: 2}), 7
  end
end
