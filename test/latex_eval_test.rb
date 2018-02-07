require 'minitest/autorun'
require_relative './../lib/latex_eval.rb'

class TestEval < Minitest::Test
  def test_that_minitest_works
    parsed = [1, 1, :add]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, 2
  end

  def test_that_postfix_notation_eval_works
    parsed = [15, 7, 1, 1, :add, :subtract, :divide, 3, :multiply, 2, 1, 1, :add, :add, :subtract]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, 5
  end

  def test_that_postfix_notation_argument_subs
    parsed = [15, :x, 1, 1, :add, :subtract, :divide, 3, :multiply, 2, 1, 1, :add, :add, :subtract]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval({x: 20}), -1.5
  end

  def test_that_parsing_works_with_brackets
    equation = "2 * (123 + 4) ^ 2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, 123, 4, :add, 2, :power, :multiply]
  end

  def test_that_powers_work
    equation = "2 ^ 3 ^ 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, 3, 3, :power, :power]
  end

  def test_that_single_letter_variables_work
    equation = "z * y * x"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [:z, :y, :x, :multiply, :multiply]
  end

  def test_that_multiple_letter_variables_work
    equation = "alpha * beta * gamma"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [:alpha, :beta, :gamma, :multiply, :multiply]
  end
end
