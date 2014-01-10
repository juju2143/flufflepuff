%{
#define SIZE 32767
#include <iostream>
#include <string>
#include <stack>
#include <vector>
using namespace std;
#define YY_DECL extern "C" int yylex()
char* filename;
string program;
stack<int> stk;
vector<char> array (SIZE);
int ptr=0;
%}
%option noyywrap
%%
"pf"		{ program+='+'; }
"bl"		{ program+='-'; }
"b"		{ program+='>'; }
"t"		{ program+='<'; }
"!"		{ program+='.'; }
"?"		{ program+=','; }
"*gasp*"	{ program+='['; }
"*pomf*"	{ program+=']'; }
.		;
\n		;
%%
main(int argc, char** argv) {
	FILE* input;
	if(argc > 1)
	{
		filename = argv[1];
		input = fopen(filename, "r");
	}
	else
	{
		filename = "stdin";
		input = stdin;
	}
	if(!input)
	{
		cout << argv[0] << ": " << filename << ": Cannot open file" << endl;
		return -1;
	}
	yyin = input;
	yylex();
	for(int i=0; i<program.length(); i++)
	{
		char instr = program[i];
		if(instr == '+') array[ptr]++;
		if(instr == '-') array[ptr]--;
		if(instr == '>') 
		{
			ptr++;
			if(ptr > SIZE) ptr=0;
		}
		if(instr == '<')
		{
			ptr--;
			if(ptr < 0) ptr=SIZE;
		}
		if(instr == '.') putchar(array[ptr]);
		if(instr == ',') array[ptr]=getchar();
		if(instr == '[') stk.push(i);
		if(instr == ']' && !stk.empty())
		{
			if(array[ptr]) i = stk.top()-1;
			stk.pop();
		}
	}
}
