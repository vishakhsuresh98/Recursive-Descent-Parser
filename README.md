# Recursive-Descent-Parser
This is a lex program to implement a recursive descent parser without backtracking for grammar G defined as follows:   
G:  S  -->  id = E     
    E  -->  TE'     
    E' -->  +TE' | -TE' | epsilon     
    T  -->  FT'     
    T' -->  *FT' | / FT' | epsilon     
    F  -->  K^F  | K     
    K  -->  (E)  | id

About the input file
--------------------
The input.txt file contains the strings which have to be verified against the parser.
   
Running the tests
-----------------
To run the lex program
  
1. Go the directory where the file is present.
2. To build the lex program, type make into the terminal.
3. The lex program has now been built and the executable file my_lex_parser is ready.
4. To run the executable file, type
   ./my_lex_parser input.txt
5. To remove the unnecessary files, type make remove into the terminal.
   The executable file my_lex_parser and lex.yy.c will be removed
