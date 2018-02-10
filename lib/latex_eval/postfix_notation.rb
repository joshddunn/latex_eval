module LatexEval 
  class PostfixNotation
    attr_reader :notation, :operations

    def initialize(notation)
      @notation = notation
      @operations = {
        add: {
          args: 2,
          operation: ->(a,b) { a + b },
        }, 
        subtract: {
          args: 2,
          operation: ->(a,b) { a - b },
        },
        multiply: {
          args: 2,
          operation: ->(a,b) { a * b },
        },
        divide: {
          args: 2, 
          operation: ->(a,b) { a / b },
        },
        power: {
          args: 2,
          operation: ->(a,b) { a ** b },
        },
        mod: {
          args: 2,
          operation: ->(a,b) { a % b },
        },
        negative: {
          args: 1,
          operation: ->(a) { -a },
        },
        positive: {
          args: 1,
          operation: ->(a) { +a },
        },
      }
    end

    def eval(subs = {})
      stack = []

      notation.each do |elem|
        if elem.is_a? Symbol
          if operations.has_key? elem
            stack.push operations[elem][:operation].call(*stack.pop(operations[elem][:args])).to_f
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
