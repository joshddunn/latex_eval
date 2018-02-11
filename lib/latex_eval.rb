require_relative "./latex_eval/equation.rb"
require_relative "./latex_eval/postfix_notation.rb"
require_relative "./latex_eval/latex.rb"

module LatexEval
  class << self

    def eval(latex, subs = {})
      parsed_latex = LatexEval::Latex.new(latex).equation
      parsed_notation = LatexEval::Equation.new(parsed_latex).postfix_notation
      eval_latex = LatexEval::PostfixNotation.new(parsed_notation)

      return eval_latex.eval(subs)
    end

    def postfix_notation(latex)
      equation = LatexEval::Latex.new(latex).equation
      return LatexEval::Equation.new(equation).postfix_notation
    end
  end
end
