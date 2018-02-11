module LatexEval
  class ParseLatex
    attr_reader :latex, :greek_letters

    def initialize(latex)
      @latex = latex
      @greek_letters = [
        'Alpha',
        'alpha',
        'Beta',
        'beta',
        'Gamma',
        'gamma',
        'Delta',
        'delta',
        'Epsilon',
        'epsilon',
        'varepsilon',
        'Zeta',
        'zeta',
        'Eta',
        'eta',
        'Theta',
        'theta',
        'vartheta',
        'Iota',
        'iota',
        'Kappa',
        'kappa',
        'varkappa',
        'Lambda',
        'lambda',
        'Mu',
        'mu',
        'Nu',
        'nu',
        'Xi',
        'xi',
        'Omicron',
        'omicron',
        'Pi',
        'pi',
        'varpi',
        'Rho',
        'rho',
        'varrho',
        'Sigma',
        'sigma',
        'varsigma',
        'Tau',
        'tau',
        'Upsilon',
        'upsilon',
        'Phi',
        'phi',
        'varphi',
        'Chi',
        'chi',
        'Psi',
        'psi',
        'Omega',
        'omega',
      ]
    end

    def parse
      parsed = latex

      parsed.gsub!(/\\left/, "")
      parsed.gsub!(/\\right/, "")

      # fractions
      while parsed.match(/\\d?frac{(.*)}{(.*)}/)
        parsed.gsub!(/\\d?frac{(.*)}{(.*)}/, '((\1)/(\2))')
      end

      # sqrt
      while parsed.match(/\\sqrt{(.*)}/)
        parsed.gsub!(/\\sqrt{(.*)}/, '((\1)^(1/2))')
      end

      # nth root
      while parsed.match(/\\sqrt(\[?(.*)(?=\])\]?)?{(.*)}/)
        parsed.gsub!(/\\sqrt(\[?(.*)(?=\])\]?)?{(.*)}/, '((\3)^(1/(\2)))')
      end

      # \cdot and \times should be *
      parsed.gsub!(/\\cdot/, "*")
      parsed.gsub!(/\\times/, "*")

      # remove remaining curly brackets 
      parsed.gsub!(/{/, "(")
      parsed.gsub!(/}/, ")")

      # cleanup variable names and multiplication
      greek_letters.each do |letter|
        parsed.gsub!(/(\\#{letter})/, ' \1 ')
      end

      # cleans up xyz to x*y*z
      while parsed.match(/((?<!\\)\b)([0-9]?[A-Za-z])([A-Za-z])/)
        parsed.gsub!(/((?<!\\)\b)([0-9]?[A-Za-z])([A-Za-z])/, '\2*\3')
      end

      parsed.gsub!(/([0-9])\s+\\([A-Za-z])/, '\1*\2')
      parsed.gsub!(/([0-9])\s*?([A-Za-z])/, '\1*\2')

      parsed.gsub!(/([A-Za-z])\s+\\([A-Za-z])/, '\1*\2')
      parsed.gsub!(/([A-Za-z])\s+([A-Za-z])/, '\1*\2')

      parsed.gsub!(/([A-Za-z])\s+([0-9])/, '\1*\2')
      parsed.gsub!(/([A-Za-z])([0-9])/, '\1*\2')

      parsed.gsub!(/(\))(\()/, '\1*\2')

      parsed.gsub!(/\\/, "")

      # cleanup spaces 
      parsed.gsub!(" ", "")

      return  parsed
    end
  end
end
