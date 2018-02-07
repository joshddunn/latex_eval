module LatexEval
  class PostfixNotation
    attr_reader :notation, :operations

    def initialize(notation)
      @notation = notation
      @operations = {
        add: lambda { |a, b| a + b },
        subtract: lambda { |a, b| a - b },
        multiply: lambda { |a, b| a * b },
        divide: lambda { |a, b| a / b },
        power: lambda { |a, b| a ** b },
      }
    end

    def eval(subs)
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

notation = [:x, 7, 1, 1, :add, :subtract, :divide, 3, :multiply, 2, 1, 1, :add, :add, :subtract]

stored = LatexEval::PostfixNotation.new(notation)

puts stored.eval({x: 15})
puts stored.eval({x: 16})
