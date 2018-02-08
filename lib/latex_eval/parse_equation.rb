module LatexEval
  class ParseEquation

    attr_reader :binary_key, :equation, :uinary_key

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
      @uinary_key = {
        "-" => {
          symbol: :negative,
        },
        "+" => {
          symbol: :positive,
        },
        # "floor" => {
        #   symbol: :floor,
        # },
        # "ceil" => {
        #   symbol: :ceil,
        # },
      }
    end

    def parse
      out = []
      bank = []
      bracket = []
      uinary = []

      # start with an assumed array
      bank.push []
      bracket.push []
      uinary.push []

      equation.gsub(" ", "").split(/([%\)\(\^*+-\/])/).each do |value|
        if value != "" 
          if value == "("
            bank.push []
            bracket.push []
            uinary.push []
          elsif value == ")"
            last = bracket.pop()
            bracket.last.concat last
            bracket.last.concat bank.pop().reverse.map { |e| binary_key[e][:symbol] } 
            bracket.last.concat uinary.pop().reverse.map { |e| uinary_key[e][:symbol] }
          elsif uinary_key.has_key? value and (bracket.last.empty? || bracket.last.length == bank.last.length)
            uinary.last.push value 
          elsif binary_key.has_key? value
            num_popped = 0
            bank.last.reverse_each do |b|
              if (binary_key[b][:right_priority] ? binary_key[b][:priority] > binary_key[value][:priority] : binary_key[b][:priority] >= binary_key[value][:priority])
                num_popped += 1
              else
                break
              end
            end
            bracket.last.concat uinary.pop().reverse.map { |e| uinary_key[e][:symbol] }
            uinary.push []
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
        # puts value
        # print "bank "
        # print bank
        # print "\n"
        # print "bracket "
        # print bracket
        # print "\n"
        # print "uinary "
        # print uinary
        # print "\n"
        # print "\n\n"
      end

      out.concat bracket.pop()
      out.concat uinary.pop().reverse.map { |e| uinary_key[e][:symbol] }
      out.concat bank.pop().reverse.map { |e| binary_key[e][:symbol] }

      return out
    end
  end
end
