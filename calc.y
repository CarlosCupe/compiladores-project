%{
    #include <stdio.h>
    #include <math.h>
    void yyerror(char *);
    int yylex(void);

    int sym[26];
%}

%token INTEGER VARIABLE
%left '+' '-'
%left '*' '/' '%'
%right '^'

%%

program:
        program statement '\n'
        | /* NULL */
        ;

statement:
        expression                      { printf("%d\n", $1); }
        | VARIABLE '=' statement        { sym[$1] = $3; $$ = $3; }
        ;

expression:
        INTEGER
        | VARIABLE                      { $$ = sym[$1]; }
        | '+''+' expression             { $$ = $3 + 1; }
        | '-''-' expression             { $$ = $3 - 1; }
        | '-' expression                { $$ = $2 * -1; }
        | expression '+' expression     { $$ = $1 + $3; }
        | expression '-' expression     { $$ = $1 - $3; }
        | expression '*' expression     { $$ = $1 * $3; }
        | expression '/' expression     { $$ = $1 / $3; }
        | expression '^' expression     { $$ = pow($1, $3); }
        | expression '%' expression     { $$ = $1 % $3; }
        | '(' expression ')'            { $$ = $2; }
        | expression '<''=' expression  { $$ = $1 <= $4 ? 1 : 0; }
        | expression '<' expression     { $$ = $1 < $3 ? 1 : 0; }
        | expression '>''=' expression  { $$ = $1 >= $4 ? 1 : 0; }
        | expression '>' expression     { $$ = $1 > $3 ? 1 : 0; }
        | expression '=''=' expression  { $$ = $1 == $4 ? 1 : 0; }
        | expression '!''=' expression  { $$ = $1 != $4 ? 1 : 0; }
        | '!' expression                { $$ = $2 == 0 ? 1 : 0; }
        | expression '&''&' expression  { $$ = $1 != 0 && $4 != 0 ? 1 : 0; }
        | expression '|''|' expression  { $$ = $1 != 0 || $4 != 0 ? 1 : 0; }
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
