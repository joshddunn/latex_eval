require_relative "./latex_eval/parse_equation.rb"
require_relative "./latex_eval/postfix_notation.rb"
require_relative "./latex_eval/parse_latex.rb"

module LatexEval
  class << self

    def parse_latex(latex, subs = {})
      parsed_latex = LatexEval::ParseLatex.new(latex).parse
      parsed_notation = LatexEval::ParseEquation.new(parsed_latex).parse
      eval_latex = LatexEval::PostfixNotation.new(parsed_notation)

      return eval_latex.eval(subs)
    end
  end
end
