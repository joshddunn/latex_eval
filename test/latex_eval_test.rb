require 'minitest/autorun'
require_relative './../lib/latex_eval.rb'

class TestEval < Minitest::Test
  # PostfixNotation
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

  def test_that_uniary_abs_works
    parsed = [-2, -1, :abs, :add]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, -1
  end

  # def test_that_uniary_floor_works
  #   parsed = [-2, -1.123, :floor, :add]
  #   assert_equal LatexEval::PostfixNotation.new(parsed).eval, -4
  # end

  # def test_that_uniary_ceil_works
  #   parsed = [-2, -1.123, :ceil, :add]
  #   assert_equal LatexEval::PostfixNotation.new(parsed).eval, -3
  # end

  # def test_that_uniary_ceil_works_after_divide
  #   parsed = [-1, -3.123, :ceil, :divide]
  #   assert_equal LatexEval::PostfixNotation.new(parsed).eval, 1.0/3.0
  # end

  # def test_that_uniary_floor_works_after_divide
  #   parsed = [-1, -2.123, :floor, :divide]
  #   assert_equal LatexEval::PostfixNotation.new(parsed).eval, 1.0/3.0
  # end

  def test_that_modulus_works
    parsed = [432, 123, :mod]
    assert_equal LatexEval::PostfixNotation.new(parsed).eval, 63 
  end

  # ParseEquation
  def test_that_parser_parses_addition
    equation = "1 + 2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, :add]
  end

  def test_that_parser_parses_subtraction
    equation = "1 - 2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, :subtract]
  end

  def test_that_parser_parses_multiplication
    equation = "1 * 2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, :multiply]
  end

  def test_that_parser_parses_division
    equation = "1 / 2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, :divide]
  end

  def test_that_parser_parses_powers
    equation = "1 ^ 2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, :power]
  end

  def test_that_parser_respects_brackets
    equation = "(1+2)^3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, :add, 3, :power]
  end

  def test_that_parser_respects_nested_brackets
    equation = "(1+(2-4))^3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 4, :subtract, :add, 3, :power]
  end

  def test_that_parser_respects_separate_brackets
    equation = "(1+(2-4))^(3 * 2)"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 4, :subtract, :add, 3, 2, :multiply, :power]
  end

  def test_that_parser_respects_separate_brackets_v2
    equation = "(1-(2-4))^(3 * 2)"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 4, :subtract, :subtract, 3, 2, :multiply, :power]
  end

  def test_that_parser_disregards_spaces
    equation = "( 1 + 2 ) ^ 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, :add, 3, :power]
  end

  def test_that_parser_recognizes_single_letter_variables
    equation = "x + y + z"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [:x, :y, :add, :z, :add]
  end

  def test_that_parser_recognizes_multi_letter_variables
    equation = "alpha + beta + gamma"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [:alpha, :beta, :add, :gamma, :add]
  end

  def test_that_parser_evaluates_multiply_divide_in_order_of_appearance
    equation = "1 * 2 / 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, :multiply, 3, :divide]
  end

  def test_that_parser_evaluates_add_subtract_in_order_of_appearance
    equation = "1 + 2 - 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, :add, 3, :subtract]
  end

  def test_that_powers_are_given_proper_priority
    equation = "3 ^ 2 ^ 2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [3, 2, 2, :power, :power]
  end

  def test_that_parser_multiplication_priority_over_addition
    equation = "1 + 2 * 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 3, :multiply, :add]
  end

  def test_that_parser_multiplication_priority_over_subtraction
    equation = "1 - 2 * 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 3, :multiply, :subtract]
  end

  def test_that_parser_division_priority_over_addition
    equation = "1 + 2 / 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 3, :divide, :add]
  end

  def test_that_parser_division_priority_over_subtraction
    equation = "1 - 2 / 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 3, :divide, :subtract]
  end

  def test_that_parser_power_priority_over_addition
    equation = "1 + 2 ^ 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 3, :power, :add]
  end

  def test_that_parser_power_priority_over_subtraction
    equation = "1 - 2 ^ 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 3, :power, :subtract]
  end

  def test_that_parser_power_priority_over_multiplication
    equation = "1 * 2 ^ 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 3, :power, :multiply]
  end

  def test_that_parser_power_priority_over_division
    equation = "1 / 2 ^ 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 3, :power, :divide]
  end

  def test_that_parser_mod_priority_over_addition
    equation = "1 + 2 % 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 3, :mod, :add]
  end

  def test_that_parser_mod_priority_over_subtraction
    equation = "1 - 2 % 3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [1, 2, 3, :mod, :subtract]
  end

  def test_that_negative_works
    equation = "- 2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, :negative]
  end

  def test_that_positive_works
    equation = "+ 2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, :positive]
  end

  def test_that_negative_works_inside_brackets
    equation = "(-2)"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, :negative]
  end

  def test_that_negative_works_outside_brackets
    equation = "(-2)"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, :negative]
  end

  def test_that_negative_works_with_others
    equation = "-2+3"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, :negative, 3, :add]
  end

  def test_that_negative_works_with_multiple_negatives
    equation = "--2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, :negative, :negative]
  end

  # def test_that_negative_works_with_floor
  #   equation = "floor(2)"
  #   assert_equal LatexEval::ParseEquation.new(equation).parse, [2, :floor]
  # end

  # def test_that_negative_works_with_floor_together
  #   equation = "floor(2) + 3"
  #   assert_equal LatexEval::ParseEquation.new(equation).parse, [2, :floor, 3, :add]
  # end

  # def test_that_negative_works_with_floor_inside
  #   equation = "floor(2 + 3)"
  #   assert_equal LatexEval::ParseEquation.new(equation).parse, [2, 3, :add, :floor]
  # end

  # def test_that_negative_works_with_ceil
  #   equation = "ceil(2)"
  #   assert_equal LatexEval::ParseEquation.new(equation).parse, [2, :ceil]
  # end

  # def test_that_negative_works_with_nested_uinary
  #   equation = "floor(ceil(2))"
  #   assert_equal LatexEval::ParseEquation.new(equation).parse, [2, :ceil, :floor]
  # end

  # def test_that_negative_works_with_multiplication
  #   equation = "2 * floor(ceil(2))"
  #   assert_equal LatexEval::ParseEquation.new(equation).parse, [2, 2, :ceil, :floor, :multiply]
  # end

  def test_that_negative_works_with_multiplication_normal
    equation = "2 * - 2"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, 2, :negative, :multiply]
  end

  def test_that_negative_works_with_multiple_negatives
    equation = "2^(-2)"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, 2, :negative, :power]
  end

  def test_that_negative_works_with_multiple_negatives
    equation = "2^(-2)"
    assert_equal LatexEval::ParseEquation.new(equation).parse, [2, 2, :negative, :power]
  end

  # parse latex
  def test_that_latex_parser_parses_fractions
    latex = '\frac{1}{2}'
    assert_equal LatexEval::ParseLatex.new(latex).parse, '((1)/(2))' 
  end

  def test_that_latex_parser_parses_fractions_recursively
    latex = '\frac{\frac{3}{4}}{2}'
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

  def test_it_all
    latex = '\frac{1}{2}\cdot3\xi+4' 
    assert_equal LatexEval.parse_latex(latex, {xi: 2}), 7
  end
end
