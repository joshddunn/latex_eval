# latex-eval

This gem lets you evaluate latex expressions. So, if you have the expression "\frac{1}{2}\*3\xi+4" you can solve it by

    LatexEval.parse_latex("\frac{1}{2}\*3\xi+4, {xi: 2})
