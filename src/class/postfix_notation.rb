module LatexEval 
  class PostfixNotation
    attr_reader :notation, :operations

    def initialize(notation)
      @notation = notation
      @operations = {
        add: ->(a,b) { a + b },
        subtract: ->(a,b) { a - b },
        multiply: ->(a,b) { a * b },
        divide: ->(a,b) { a / b },
        power: ->(a,b) { a ** b },
      }
    end

    def eval(subs = {})
      stack = []

      notation.each do |elem|
        if elem.is_a? Symbol
          if operations.has_key? elem
            b = stack.pop()
            a = stack.pop()

            stack.push operations[elem].call(a, b)
          else
            stack.push subs[elem].to_f
          end
        else
          stack.push elem.to_f
        end
      end

      return stack.first
    end
  end
end
