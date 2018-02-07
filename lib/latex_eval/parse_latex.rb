module LatexEval
  class ParseLatex
    attr_reader :latex

    def initialize(latex)
      @latex = latex
    end

    def parse
      parsed = latex

      # fractions
      while parsed.match(/\\frac{(.*)}{(.*)}/)
        parsed.gsub!(/\\frac{(.*)}{(.*)}/, '((\1)/(\2))')
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
      parsed.gsub!(/([0-9])\\([A-Za-z])/, '\1*\2')
      parsed.gsub!(/([A-Za-z])\\([A-Za-z])/, '\1*\2')
      parsed.gsub!(/([A-Za-z])([0-9])/, '\1*\2')
      parsed.gsub!(/(\))(\()/, '\1*\2')
      parsed.gsub!(/\\/, "")

      # cleanup spaces 
      parsed.gsub!(" ", "")

      return  parsed
    end
  end
end
