# Recursive-Descent-Parser
lex program to implement a Recursive Descent parser without backtracking parser for grammar G defines as follows   G:  S -> id = E     E -> TE'     E'-> +TE' | -TE' | e     T -> FT'     T'-> *FT' | / FT' | e     F -> K^F  | K     K -> (E)  | id
