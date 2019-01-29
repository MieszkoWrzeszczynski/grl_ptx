%{
    #include <stdio.h>
    #include <string.h>

    char* defaultNodeShapeStart = "";
    char* defaultNodeStyleStart = "";
    char* defaultNodeShape = "";
    char* defaultNodeStyle = "";


    int yywrap(){
        return 1;
    }

    int main(){
        yyparse();
        return 0;
    }

    void yyerror(const char *str){
        fprintf(stderr,"error: %s\n",str);
    }

%}

%union
{
    char *str;
}

%token STYLE SHAPE BEGIN_D BEGIN_G NODE EDGE END DIRECTED NONDIRECTED ENDLINE
%token <str> STRINGNAME ID DEFAULTNODESHAPE DEFAULTNODESTYLE

%%

commands: /* empty */
        | commands command
        ;

command: startGraph
        | endGraph
        | createOneEdge
        | createOneNode
        | defaultNodeShape
        | defaultNodeStyle
        ;

startGraph:
        BEGIN_G ENDLINE { printf("graph {"); }
        | BEGIN_G STRINGNAME ENDLINE { printf("graph %s {", $2); }
        | BEGIN_D ENDLINE { printf("digraph {"); }
        | BEGIN_D STRINGNAME ENDLINE { printf("digraph %s {", $2); }
        ;

createOneNode:
        buildNoLabel
        | buildWithLabel
        ;

buildNoLabel:
        NODE ID ENDLINE { printf("\t%s [%s%s%s%s];", $2, defaultNodeStyleStart, defaultNodeStyle, defaultNodeShapeStart, defaultNodeShape); }
        | NODE ID STYLE STRINGNAME ENDLINE { printf("\t%s [%s%s style=%s];", $2, defaultNodeShapeStart, defaultNodeShape, $4); }
        | NODE ID SHAPE STRINGNAME ENDLINE { printf("\t%s [shape=%s%s%s];", $2, $4, defaultNodeStyleStart, defaultNodeStyle); }
        | NODE ID STYLE STRINGNAME SHAPE STRINGNAME ENDLINE { printf("\t%s [shape=%s style=%s];", $2, $6, $4); }
        | NODE ID SHAPE STRINGNAME STYLE STRINGNAME ENDLINE { printf("\t%s [shape=%s style=%s];", $2, $4, $6); }

buildWithLabel:
        NODE ID STRINGNAME ENDLINE { printf("\t%s [label=%s%s%s%s%s];", $2, $3, defaultNodeStyleStart, defaultNodeStyle, defaultNodeShapeStart, defaultNodeShape); }
        | NODE ID STRINGNAME SHAPE STRINGNAME ENDLINE { printf("\t%s [label=%s shape=%s%s%s];", $2, $3, $5, defaultNodeStyleStart, defaultNodeStyle); }
        | NODE ID STRINGNAME STYLE STRINGNAME ENDLINE { printf("\t%s [label=%s%s%s style=%s];", $2, $3, defaultNodeShapeStart, defaultNodeShape, $5); }
        | NODE ID STRINGNAME STYLE STRINGNAME SHAPE STRINGNAME ENDLINE { printf("\t%s [label= %s shape=%s style=%s];", $2, $3, $7, $5); }
        | NODE ID STRINGNAME SHAPE STRINGNAME STYLE STRINGNAME ENDLINE { printf("\t%s [label= %s shape=%s style=%s];", $2, $3, $5, $7); }


createOneEdge:
        buildNonDirected
        |
        buildDirected
        ;

buildDirected:
         EDGE ID DIRECTED ID STRINGNAME ENDLINE { printf("\t%s -> %s [label=%s];", $2, $4, $5); }
        | EDGE ID DIRECTED ID ENDLINE { printf("\t%s -> %s;", $2, $4); }
        | EDGE ID DIRECTED ID STRINGNAME STYLE STRINGNAME ENDLINE { printf("\t%s -> %s [label=%s, style=%s];", $2, $4, $5, $7); }
        | EDGE ID DIRECTED ID STYLE STRINGNAME ENDLINE { printf("\t%s -> %s [style=%s];", $2, $4, $6); }

buildNonDirected:
         EDGE ID NONDIRECTED ID STRINGNAME ENDLINE { printf("\t%s -- %s [label=%s];", $2, $4, $5); }
        | EDGE ID NONDIRECTED ID ENDLINE { printf("\t%s -- %s;", $2, $4); }
        | EDGE ID NONDIRECTED ID STRINGNAME STYLE STRINGNAME ENDLINE { printf("\t%s -> %s [label=%s, style=%s];", $2, $4, $5, $7); }
        | EDGE ID NONDIRECTED ID STYLE STRINGNAME ENDLINE { printf("\t%s -> %s [style=%s];", $2, $4, $6); }

endGraph:
        END ENDLINE
        {
                printf("}");
        }
        ;

defaultNodeShape:
        DEFAULTNODESHAPE STRINGNAME ENDLINE
        {
              defaultNodeShapeStart = " shape=";
              defaultNodeShape = $2;
        }
        ;

defaultNodeStyle:
        DEFAULTNODESTYLE STRINGNAME ENDLINE
        {
              defaultNodeStyleStart = " style=";
              defaultNodeStyle = $2;
        }
        ;
