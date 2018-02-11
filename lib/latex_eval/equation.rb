module LatexEval
  class Equation

    attr_reader :binary_key, :equation, :unary_key

    def initialize(equation)
      @equation = equation
      @binary_key = {
        "+" => {
          symbol: :add,
          priority: 0,
          right_priority: false
        },
        "-" => {
          symbol: :subtract,
          priority: 0,
          right_priority: false
        },
        "*" => {
          symbol: :multiply,
          priority: 1,
          right_priority: false
        },
        "/" => {
          symbol: :divide,
          priority: 1,
          right_priority: false
        },
        "%" => {
          symbol: :mod,
          priority: 1,
          right_priority: false
        },
        "^" => {
          symbol: :power,
          priority: 2,
          right_priority: true
        }
      }
      @unary_key = {
        "-" => {
          symbol: :negative,
        },
        "+" => {
          symbol: :positive,
        },
      }
    end

    def postfix_notation
      out = []
      bank = []
      bracket = []
      unary = []

      # start with an assumed array
      bank.push []
      bracket.push []
      unary.push []

      equation.gsub(" ", "").split(/([%\)\(\^*+-\/])/).each do |value|
        if value != "" 
          if value == "("
            bank.push []
            bracket.push []
            unary.push []
          elsif value == ")"
            last = bracket.pop()
            bracket.last.concat last
            bracket.last.concat bank.pop().reverse.map { |e| binary_key[e][:symbol] } 
            bracket.last.concat unary.pop().reverse.map { |e| unary_key[e][:symbol] }
          elsif unary_key.has_key? value and (bracket.last.empty? || bracket.last.length == bank.last.length)
            unary.last.push value 
          elsif binary_key.has_key? value
            num_popped = 0
            bank.last.reverse_each do |b|
              if (binary_key[b][:right_priority] ? binary_key[b][:priority] > binary_key[value][:priority] : binary_key[b][:priority] >= binary_key[value][:priority])
                num_popped += 1
              else
                break
              end
            end
            bracket.last.concat unary.pop().reverse.map { |e| unary_key[e][:symbol] }
            unary.push []
            bracket.last.concat bank.last.pop(num_popped).reverse.map { |e| binary_key[e][:symbol] }
            bank.last.push value
          else
            if /[a-zA-Z]+/.match(value)
              bracket.last.push value.to_sym
            else
              bracket.last.push value.to_f
            end
          end
        end
      end

      out.concat bracket.pop()
      out.concat unary.pop().reverse.map { |e| unary_key[e][:symbol] }
      out.concat bank.pop().reverse.map { |e| binary_key[e][:symbol] }

      return out
    end
  end
end
