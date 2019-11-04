%{
    #include <stdio.h>
    #include <math.h>
    void yyerror(char *);
    int yylex(void);

    int sym[26];
    float ans;
%}

%token INTEGER VARIABLE OR AND SUM REST EQUAL NEQUAL ANS LEQUAL GEQUAL
%left '+' '-'
%left '*' '/' '%'
%left OR AND
%right '^' 

%%

program:
        program statement '\n'
        | /* NULL */
        ;

statement:
        expression                      { ans = $1; printf("%d\n", $1); }
        | VARIABLE '=' statement        { sym[$1] = $3; $$ = $3; }
        ;

expression:
        INTEGER
        | ANS                           { $$ = ans; }
        | VARIABLE                      { $$ = sym[$1]; }
        | SUM expression                { $$ = $2 + 1; }
        | REST expression               { $$ = $2 - 1; }
        | '-' expression                { $$ = $2 * -1; }
        | expression '+' expression     { $$ = $1 + $3; }
        | expression '-' expression     { $$ = $1 - $3; }
        | expression '*' expression     { $$ = $1 * $3; }
        | expression '/' expression     { $$ = $1 / $3; }
        | expression '^' expression     { $$ = pow($1, $3); }
        | expression '%' expression     { $$ = $1 % $3; }
        | '(' expression ')'            { $$ = $2; }
        | expression '<' expression     { $$ = $1 < $3 ? 1 : 0; }
        | expression '>' expression     { $$ = $1 > $3 ? 1 : 0; }
        | expression LEQUAL expression  { $$ = $1 <= $3 ? 1 : 0; }
        | expression GEQUAL expression  { $$ = $1 >= $3 ? 1 : 0; }
        | expression EQUAL expression   { $$ = $1 == $3 ? 1 : 0; }
        | expression NEQUAL expression  { $$ = $1 != $3 ? 1 : 0; }
        | '!' expression                { $$ = $2 == 0 ? 1 : 0; }
        | expression AND expression     { $$ = $1 != 0 && $3 != 0 ? 1 : 0; }
        | expression OR expression      { $$ = $1 != 0 || $3 != 0 ? 1 : 0; }
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
