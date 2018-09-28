CC=g++ -std=c++11 

all: my_lex_parser

lex.yy.c: program.l
	lex program.l

my_lex_parser: lex.yy.c 
	$(CC) lex.yy.c -ll -o my_lex_parser

remove:
	rm my_lex_parser
	rm lex.yy.c