# latex\_eval

This gem can be used to safely evaluate simple latex expressions.

For example, if you want to evaluate `\frac{\xi}{2}+3` where `\xi = 3` you can do

    LatexEval.eval('\frac{\xi}{2}+3', {xi: 3})

However, if you are going to be evaluating the expression many times, it is best to save the postfix notation first.

    postfix = LatexEval.postfix_notation('\frac{\xi}{2}+3')
    LatexEval::PostfixNotation.eval(postfix, {xi: 3})

This gem is made up of 3 classes. `Latex`, `Equation`, and `PostfixNotation`. I will explain their uses.

## Latex

The latex class is used to convert your latex into an equation. For example,

    LatexEval::Latex.new('\frac{\xi}{2}+3').equation

will output `((xi)/(2)+3)`.

Currently, the `equation` method for the `Latex` class supports the following latex expressions:

- capital and lowercase Greek letters (`\alpha`, `\Beta`, etc.)
- single letter variables (`a`, `b`, ..., `z`)
- fractions in the form of `\frac{}{}` and `\dfrac{}{}`
- roots in the form `\sqrt{}` and `\sqrt[]{}`
- binary operators
  - multiplication (\*, `\cdot`, `\times`)
  - division(/)
  - powers (^)
  - modulus (%)
  - addition (+)
  - subtraction (-)
- unary operators
  - positive (+)
  - negative (-)

## Equation

The equation class is used to convert your equations into postfix notation. For example,

    LatexEval::Equation.new('((xi)/(2)+3)').postfix_notation

will output `[3, :xi, 2, :divide, :add]`.

Currently, the `postfix_notation` method for the `Equation` class can interpret

- brackets
- binary operators
  - multiplication (\*)
  - division(/)
  - powers (^)
  - modulus (%)
  - addition (+)
  - subtraction (-)
- unary operators
  - positive (+)
  - negative (-)

and will adhere to the generally accepted order of operations.

## PostfixNotation

The postfix equation class is used to safely evaluate postfix notation. For example,

    LatexEval::PostfixNotation.new([3, :xi, 2, :divide, :add]).eval({xi: 3})

will output `4.5`.

The `eval` method accepts one argument, which is a hash of variable values.

Currently, the `eval` method for the `PostfixNotation` class can interpret

- binary operators
  - :multiply
  - :divide
  - :power
  - :mod
  - :add
  - :subtract
- unary operators
  - :positive
  - :negative
