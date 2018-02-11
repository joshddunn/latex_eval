require 'minitest/autorun'
require_relative './../lib/latex_eval.rb'

class TestEquation < Minitest::Test
  def test_that_parser_parses_addition
    equation = "1 + 2"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, :add]
  end

  def test_that_parser_parses_subtraction
    equation = "1 - 2"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, :subtract]
  end

  def test_that_parser_parses_multiplication
    equation = "1 * 2"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, :multiply]
  end

  def test_that_parser_parses_division
    equation = "1 / 2"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, :divide]
  end

  def test_that_parser_parses_powers
    equation = "1 ^ 2"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, :power]
  end

  def test_that_parser_respects_brackets
    equation = "(1+2)^3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, :add, 3, :power]
  end

  def test_that_parser_respects_nested_brackets
    equation = "(1+(2-4))^3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 4, :subtract, :add, 3, :power]
  end

  def test_that_parser_respects_separate_brackets
    equation = "(1+(2-4))^(3 * 2)"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 4, :subtract, :add, 3, 2, :multiply, :power]
  end

  def test_that_parser_respects_separate_brackets_v2
    equation = "(1-(2-4))^(3 * 2)"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 4, :subtract, :subtract, 3, 2, :multiply, :power]
  end

  def test_that_parser_disregards_spaces
    equation = "( 1 + 2 ) ^ 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, :add, 3, :power]
  end

  def test_that_parser_recognizes_single_letter_variables
    equation = "x + y + z"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [:x, :y, :add, :z, :add]
  end

  def test_that_parser_recognizes_multi_letter_variables
    equation = "alpha + beta + gamma"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [:alpha, :beta, :add, :gamma, :add]
  end

  def test_that_parser_evaluates_multiply_divide_in_order_of_appearance
    equation = "1 * 2 / 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, :multiply, 3, :divide]
  end

  def test_that_parser_evaluates_add_subtract_in_order_of_appearance
    equation = "1 + 2 - 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, :add, 3, :subtract]
  end

  def test_that_powers_are_given_proper_priority
    equation = "3 ^ 2 ^ 2"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [3, 2, 2, :power, :power]
  end

  def test_that_parser_multiplication_priority_over_addition
    equation = "1 + 2 * 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 3, :multiply, :add]
  end

  def test_that_parser_multiplication_priority_over_subtraction
    equation = "1 - 2 * 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 3, :multiply, :subtract]
  end

  def test_that_parser_division_priority_over_addition
    equation = "1 + 2 / 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 3, :divide, :add]
  end

  def test_that_parser_division_priority_over_subtraction
    equation = "1 - 2 / 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 3, :divide, :subtract]
  end

  def test_that_parser_power_priority_over_addition
    equation = "1 + 2 ^ 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 3, :power, :add]
  end

  def test_that_parser_power_priority_over_subtraction
    equation = "1 - 2 ^ 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 3, :power, :subtract]
  end

  def test_that_parser_power_priority_over_multiplication
    equation = "1 * 2 ^ 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 3, :power, :multiply]
  end

  def test_that_parser_power_priority_over_division
    equation = "1 / 2 ^ 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 3, :power, :divide]
  end

  def test_that_parser_mod_priority_over_addition
    equation = "1 + 2 % 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 3, :mod, :add]
  end

  def test_that_parser_mod_priority_over_subtraction
    equation = "1 - 2 % 3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [1, 2, 3, :mod, :subtract]
  end

  def test_that_negative_works
    equation = "- 2"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [2, :negative]
  end

  def test_that_positive_works
    equation = "+ 2"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [2, :positive]
  end

  def test_that_negative_works_inside_brackets
    equation = "(-2)"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [2, :negative]
  end

  def test_that_negative_works_outside_brackets
    equation = "-(2)"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [2, :negative]
  end

  def test_that_negative_works_with_others
    equation = "-2+3"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [2, :negative, 3, :add]
  end

  def test_that_negative_works_with_multiple_negatives
    equation = "--2"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [2, :negative, :negative]
  end

  def test_that_negative_works_with_multiplication_normal
    equation = "2 * - 2"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [2, 2, :negative, :multiply]
  end

  def test_that_negative_works_with_multiple_negatives_2
    equation = "2^(-2)"
    assert_equal LatexEval::Equation.new(equation).postfix_notation, [2, 2, :negative, :power]
  end
end
