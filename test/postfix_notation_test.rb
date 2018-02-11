require 'minitest/autorun'
require_relative './../lib/latex_eval.rb'

class TestPostfixNotation < Minitest::Test
  def test_that_eval_evals_add
    parsed = [3, 5, :add]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, 8
  end

  def test_that_eval_evals_subtract
    parsed = [3, 5, :subtract]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, -2
  end

  def test_that_eval_evals_multiply
    parsed = [3, 5, :multiply]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, 15
  end

  def test_that_eval_evals_divide
    parsed = [3, 5, :divide]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, 0.6
  end

  def test_that_eval_evals_power
    parsed = [3, 5, :power]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, 243
  end

  def test_that_eval_evals_variables
    parsed = [:x, :y, :power]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval({x: 13, y: 3}), 2197
  end

  def test_that_negatives_work
    parsed = [-2, -1, :subtract]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, -1
  end

  def test_that_uniary_negative_works
    parsed = [-2, -1, :negative, :add]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, -1
  end

  def test_that_uniary_positive_works
    parsed = [-2, -1, :positive, :add]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, -3
  end

  def test_that_modulus_works
    parsed = [432, 123, :mod]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, 63 
  end
end
