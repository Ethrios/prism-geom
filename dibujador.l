%option noyywrap


%{
#include<stdio.h>
FILE *file;
%}

DIGIT    [0-9]
ID       [a-zA-Z][a-zA-Z0-9]*

%%


("+"|"-")?{DIGIT}+("."{DIGIT}*)?   fprintf(file, "<punto_flotante> %s\n", yytext); 

Inicio|Fin|Dibujar|Rellenar|Color|Borde|Rotar|Escalar|Trasladar|Sobre|Funcion|Flotante|Vector2d|Vector3d|Punto|Recta|Curva|Plano|Triangulo|Cuadrilatero|Elipse|Circunferencia|Parabola|Hiperbola|Poliedro|Cilindro|Cono|Esfera|NEGRO|AZUL|CIAN|GRIS|VERDE|MAGENTA|NARANJA|ROSADO|ROJO|BLANCO|AMARILLO       {
            fprintf(file, "<palabra_reservada> %s\n", yytext );
            }

{ID}        fprintf(file, "<identificador> %s\n", yytext );

"=" fprintf(file,"<asignacion>: %s\n", yytext );

"+"|"-"|"*"|"/"   fprintf(file, "<operador> %s\n", yytext );

"{"|"}"|";"|","|"("|")"   fprintf(file, "<delimitador> %s\n", yytext);

[ \t\n]+          /* eat up whitespace */

.           fprintf(file, "<caracter_invalido> %s\n", yytext );

%%

int main( int argc, char **argv )
    {
	 file = fopen("output.txt", "w+");
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
            yyin = fopen( argv[0], "r" );
    else
            yyin = stdin;

    yylex();
	fclose(file);
    }
