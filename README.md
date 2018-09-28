# Recursive-Descent-Parser
Lex program to implement a Recursive Descent parser without backtracking for grammar G defines as follows   
G:  S -> id = E     
    E -> TE'     
    E'-> +TE' | -TE' | epsilon     
    T -> FT'     
    T'-> *FT' | / FT' | epsilon     
    F -> K^F  | K     
    K -> (E)  | id
