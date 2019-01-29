make: parser.y lexer.l demoGraph
		lex lexer.l
		yacc -d parser.y
		gcc lex.yy.c y.tab.c -o grl.out
		./grl.out < demoGraph > demoGraph.dot
		dot -Tps demoGraph.dot -o demoGraph.ps

clean:
		rm -f grl.out demoGraph.dot demoGraph.ps lex.yy.c y.tab.c y.tab.h
