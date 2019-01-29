%{
    #include <stdio.h>
    #include "y.tab.h"
%}

%%
"$".*                             ;
" "                               ;
";"                               return ENDLINE;
DEFAULT_SHAPE                     yylval.str = strdup(yytext); return DEFAULTNODESHAPE;
DEFAULT_STYLE                     yylval.str = strdup(yytext); return DEFAULTNODESTYLE;
STYLE=                            yylval.str = strdup(yytext); return STYLE;
SHAPE=                            return SHAPE;
BEGIN_G                           return BEGIN_G;
BEGIN_D                           return BEGIN_D;
NODE                              return NODE;
EDGE                              return EDGE;
END                               return END;
"-->"                             return DIRECTED;
"---"                             return NONDIRECTED;
STYLE=                            return STYLE;
\"([a-z]|[A-Z]|[0-9]|" "|\n)*\"   yylval.str = strdup(yytext); return STRINGNAME;
([a-z]|[A-Z]|[0-9])+              yylval.str = strdup(yytext); return ID;
