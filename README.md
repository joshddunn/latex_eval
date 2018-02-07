# latex-eval

This gem lets you evaluate latex expressions. So, if you have the expression "\frac{1}{2}\*3\xi+4" you can solve it by

    LatexEval.parse_latex("\frac{1}{2}\*3\xi+4, {xi: 2})

### Currently supported

- \frac{}{}
- \sqrt[]{}
- \sqrt{}
- symbol evaluation

### Bugs

- single letter variables like `x` and `y` are not being processed properly
