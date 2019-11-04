%{
    #include "y.tab.h"
    #include <stdlib.h>
    void yyerror(char *);
%}

%%

"ANS"       {
                return ANS;
            }

[a-z]       {
                yylval = *yytext - 'a';
                return VARIABLE;
            }

[0-9]+      {
                yylval = atoi(yytext);
                return INTEGER;
            }

"||"        { return OR; }
"&&"        { return AND; }

"++"        { return SUM; }
"--"        { return REST; }

"=="        { return EQUAL; }
"!="        { return NEQUAL; }

"<="        { return LEQUAL; }
">="        { return GEQUAL; }

[<>=!]        { return *yytext; }

[-+()=/%*^\n]   { return *yytext; }

[ \t]   ;       /* skip whitespace */

.               yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}
