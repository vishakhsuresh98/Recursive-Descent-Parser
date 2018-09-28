%{
  #include <iostream>		
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <map>
  using namespace std;

  // global Variables
  char tokenized_form[1000]; // Tokenized form : x=x+5
  string tokenized_output; // Tokenized form : id1=id1+intconst
  char current_token; // current scanned token 
  int count=0;

  // function declarations
  char get_token()
  {
  	 // function to get the next token 
     return tokenized_form[count++];
  }

  bool is_digit(char ch) 
  {	
  	 // utility function to check if the check if ch is a digit or not
	 int ascii=(int)ch;
	 if(ascii >= 48 && ascii <= 57)
		 return true;
	 else 
		 return false;	
  }

  bool is_alphabet(char ch)
  {
  	 // utility function to check if the check if ch is an alphabet or not
	 int ascii=(int)ch;
	 if((ascii >= 65 && ascii <= 90)||(ascii >= 97 && ascii <= 122))
	 	 return true;
	 else
		 return false;	
  }

  bool is_alphabet_or_digit(char ch)
  {
  	 // utility function to check if the check if ch is an alphabet or digit or not
	 return (is_alphabet(ch) || is_digit(ch));
  }

  int tokenize(string); // function to tokenize
  // procedures for non-terminals
  int K();
  int FP();
  int F();
  int TP();
  int T();
  int EP();
  int E();
  int S();
%}

%%

.* {
		// Tokenise the input string
		int flag=tokenize(yytext);
		/* 
		 * flag=1 ===> Valid statement (No semicolon is present)  
		 * flag=0 ===> Invalid statement (semicolon is present)
		 */
		if(!flag)
			cout<<"INVALID STATEMENT";	
		else
		{
			// start parsing the input
			count=0;
			current_token=get_token();
			if(S())
				printf("%-25s%-100s%-10s", tokenized_output.c_str(), "VALID STATEMENT", " ");
			else
				cout<<"INVALID STATEMENT";	
		}	
   }


%%

int tokenize(string yytext)
{
	tokenized_output="";
	int id_count=1; // identifier count
	map<string,int> identifier_map; // map to keep track of the identifiers encountered
	int i=0; // iterator over the input
	int c=0;
	for(i=0;i<yytext.length();i++)
	{
		// validating identifier
		if(is_alphabet(yytext[i]) || yytext[i]=='_')
		{
			string id;
			while(is_alphabet_or_digit(yytext[i]) || yytext[i]=='_') 
			{
				id+=yytext[i];
				i++;
			}
			tokenized_output+="id";

			// if id has not been encountered ==> add it to map
			map<string,int>::iterator it=identifier_map.find(id);
			if(it==identifier_map.end())
			{
				identifier_map.insert(pair<string,int> (id, id_count));
				tokenized_output+=to_string(id_count);
				id_count++;
			}	
			else // id has already been encountered
			{
				tokenized_output+=to_string(identifier_map[id]);
			}	
			tokenized_form[c++]='i';
			i--;
		}

		// validating int and float constants
		else if(is_digit(yytext[i]) || yytext[i]=='.')
		{
			bool is_float=false; // 
			if(yytext[i]=='.')
				is_float=true;
			while(is_digit(yytext[i])) 
				i++;
			if(yytext[i]=='.')
			{
				// if there is a decimal point ==> it is a float
				is_float=true; 
				i++;
			}
			while(is_digit(yytext[i])) 
				i++;
			tokenized_form[c++]='c';
			i--;
			if(is_float)
				tokenized_output+="floatconst";
			else
				tokenized_output+="intconst";	
		}
	
		// validating arithmetic operators
		else if(yytext[i]=='+' || yytext[i]=='-' || yytext[i]=='*' || yytext[i]=='/' || \
			    yytext[i]=='=' || yytext[i]=='(' || yytext[i]==')' || yytext[i]=='^')
		{
			tokenized_output+=yytext[i];
			tokenized_form[c++]=yytext[i];
		}

		else if(yytext[i]=='$') 
			break;

		else if(yytext[i]==';' || yytext[i]==',' || yytext[i]=='%')
			return 0;	
	}

	tokenized_form[c++]='$'; // To delimit the tokenized string
	tokenized_form[c]='\0';
	return 1;
}

// Functions for each non-terminals

int S()
{
	// S --> id = E
	if(current_token=='i')
	{
		current_token=get_token();
		if(current_token=='=')
		{
			current_token=get_token();
			if(E())
			{ 
				if(current_token=='$') // End of the string return true
					return 1; 
				else 
					return 0;
				}
			}
			else
				return 0;
		}
	else if(current_token=='$') // Empty string return true
		return 1;
	else
		return 0;
}

int E()
{
	// E --> TE'
	if(T())
		return EP();
	else
		return 0;
}

int EP()
{
	// E' --> +TE' | -TE' | epsilon
	if(current_token=='+' || current_token=='-')
	{
		current_token=get_token();
		if(T())
			return EP();
		else
			return 0;
	}
	else if(current_token==')' || current_token=='$')
		return 1;
	else
		return 0;
}

int T()
{
	// T --> FT'
	if(F())
		return TP();
	else
		return 0;
}

int TP()
{
	// T' --> *FT' | /FT' | epsilon
	if(current_token=='*' || current_token=='/')
	{
		current_token=get_token();
		if(F())
			return TP();
		else
			return 0;
	}
	else if(current_token=='+' || current_token=='-' ||current_token==')' || current_token=='$')
		return 1;
	else
		return 0;
}

int F()
{
	// F --> KF'
	if(K())
		return FP();
	else
		return 0;
}

int FP()
{
	// F' --> ^F | e
	if(current_token=='^')
	{
		current_token=get_token();
		return F();
	}
	else if(current_token=='*' || current_token=='/' ||current_token=='+' || current_token=='-' ||current_token==')' || current_token=='$')
		return 1;
	else 
		return 0;
}

int K()
{
	// K --> (E) | id | const
	if(current_token=='(')
	{
		current_token=get_token();
		if(E())
		{
			if(current_token==')'){	current_token=get_token(); 
				return 1;}
			else return 0;
		}
		else
			return 0;
	}
	else if(current_token=='i'|| current_token=='c')
	{
		current_token=get_token();
		return 1;
	}
	else
		return 0;
}

int main(int argc, char* argv[]) 
{
	extern FILE *yyin;
    FILE *fh;
    yyin = fopen(argv[1], "r");
    yylex();
    cout<<endl;
    return 0;
} 