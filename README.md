# Calc
Calc is a simple stack based terminal calculator

## Usage
The calculator uses a stack based method of calculation called reverse polish notation (RPN)

The numbers and entered before their operand
This removes the need for parenteses and allows you to easier perform an operation on the last result

Tokens can be entered either all at once or by pressing enter between each
`2 2 + 4 *` is equivalent to `(2+2)*4`
```
2 2 +
4 *
```
Adds 2 and 2 and shows the result
Later multiplies it by 4

## Similarities
This project may seem familiar to the builting calculator of Emacs, and that's because it is.
I thought it was a great calculator and wanted to keep it outside of emacs.
This made me create my own giving me an opportinity to learn more lua, which I think is quite neat.
