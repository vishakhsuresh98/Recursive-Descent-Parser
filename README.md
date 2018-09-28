# Recursive-Descent-Parser
Lex program to implement a Recursive descent parser without backtracking for grammar G defined as follows   
G:  S -> id = E     
    E -> TE'     
    E'-> +TE' | -TE' | epsilon     
    T -> FT'     
    T'-> *FT' | / FT' | epsilon     
    F -> K^F  | K     
    K -> (E)  | id
