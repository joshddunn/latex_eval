require 'minitest'
require_relative './../lib/latex_eval.rb'

class TestParseLatex < Minitest::Test
  def test_that_latex_parser_parses_fractions
    latex = '\frac{1}{2}'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '((1)/(2))' 
  end

  def test_that_latex_parser_parses_fractions_recursively
    latex = '\frac{\frac{3}{4}}{2}'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '((((3)/(4)))/(2))' 
  end

  def test_that_latex_parser_parses_dfractions
    latex = '\dfrac{1}{2}'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '((1)/(2))' 
  end

  def test_that_latex_parser_parses_dfractions_recursively
    latex = '\dfrac{\dfrac{3}{4}}{2}'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '((((3)/(4)))/(2))' 
  end

  def test_that_latex_parser_parses_cdot
    latex = '1\cdot2'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '1*2' 
  end

  def test_that_latex_parser_parses_times
    latex = '1\times2'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '1*2' 
  end

  def test_that_latex_parser_parses_powers
    latex = '1^{23}'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '1^(23)' 
  end

  def test_that_latex_parser_parses_variable_names
    latex = '\xi'
    assert_equal LatexEval::ParseLatex.new(latex).parse, 'xi' 
  end

  def test_that_latex_parser_adds_missing_multiplication_before_variable
    latex = '2\xi'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '2*xi' 
  end

  def test_that_latex_parser_adds_missing_multiplication_after_variable
    latex = '\xi2'
    assert_equal LatexEval::ParseLatex.new(latex).parse, 'xi*2' 
  end

  def test_that_latex_parser_adds_missing_multiplication_between_variable
    latex = '\alpha\beta'
    assert_equal LatexEval::ParseLatex.new(latex).parse, 'alpha*beta' 
  end

  def test_that_latex_parser_adds_missing_multiplication_between_brackets
    latex = '(1)(2)'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '(1)*(2)' 
  end

  def test_that_latex_parser_parses_nth_root
    latex = '\sqrt[3]{2}'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '((2)^(1/(3)))' 
  end

  def test_that_latex_parser_parses_sqrt
    latex = '\sqrt{2}'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '((2)^(1/2))' 
  end

  def test_works_with_typical_variables
    latex = '\xi x'
    assert_equal LatexEval::ParseLatex.new(latex).parse, 'xi*x' 
  end

  def test_works_with_typical_variable
    latex = '2x'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '2*x' 
  end

  def test_works_with_left_and_right
    latex = '\left(x + 2\right)'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '(x+2)' 
  end

  def test_works_with_abs
    latex = '2 % 3'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '2%3' 
  end

  def test_works_with_abs_and_variables
    latex = 'x % y'
    assert_equal LatexEval::ParseLatex.new(latex).parse, 'x%y' 
  end
end
