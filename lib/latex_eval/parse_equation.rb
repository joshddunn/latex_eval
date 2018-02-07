module LatexEval
  class ParseEquation

    attr_reader :key, :equation

    def initialize(equation)
      @equation = equation
      @key = {
        "+" => {
          symbol: :add,
          priority: 0
        },
        "-" => {
          symbol: :subtract,
          priority: 0
        },
        "*" => {
          symbol: :multiply,
          priority: 1
        },
        "/" => {
          symbol: :divide,
          priority: 1
        },
        "^" => {
          symbol: :power,
          priority: 2
        },
        "(" => {
          symbol: :left_bracket,
          priority: 3
        },
        ")" => {
          symbol: :right_bracket,
          priority: 3
        }
      }
    end

    def parse
      out = []
      bank = []

      # major refactoring required
      equation.gsub(" ", "").split(/([\)\(\^*+-\/])/).each do |value|
        if value != "" 
          if key.has_key? value
            num_popped = 0
            bank.reverse_each do |b|
              if b != "(" and key[b][:priority] > key[value][:priority]
                num_popped += 1
                out.push key[b][:symbol]
              else
                break
              end
            end
            bank.pop(num_popped)

            if value == ")"
              num_popped = 0
              bank.reverse_each do |b|
                num_popped += 1
                if b == "("
                  break
                else
                  out.push key[b][:symbol]
                end
              end

              bank.pop(num_popped)
            else
              bank.push value
            end
          else
            if /[a-zA-Z]+/.match(value)
              out.push value.to_sym
            else
              out.push value.to_f
            end
          end
        end
      end

      bank.reverse_each do |b|
        out.push key[b][:symbol] unless b == "(" or b == ")" 
      end

      return out
    end
  end
end
