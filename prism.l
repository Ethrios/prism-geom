%option noyywrap

%{
#include<stdio.h>
#include"prism.tab.h"
#include<QString>
FILE *file;
QString output;
int line = 0;
%}

DIGIT    [0-9]
ID       [a-zA-Z][a-zA-Z0-9]*

%%


("+"|"-")?{DIGIT}+("."{DIGIT}*)?   {    output+="PTO_FLOT,"; output+=yytext; output+='\n';
									return PTO_FLOT;}

Inicio			{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return INICIO;}

Fin			{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return FIN;}

Dibujar		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return DIBUJAR;}

Fondo 				{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return FONDO;}

Rellenar	{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return RELLENAR;}

Color		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return COLOR;}

Rotar		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return ROTAR;}

Escalar 	{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return ESCALAR;}
								
Trasladar	{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return TRASLADAR;}

Sobre	{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return SOBRE;}

Flotante	{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return FLOTANTE;}

Vector2d	{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return VECT2D;}

Vector3d	{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return VECT3D;}

Punto		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return PUNTO;}

Recta		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return RECTA;}

Curva		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return CURVA;}

Plano		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return PLANO;}

Triangulo		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return TRIANGULO;}

Cuadrilatero		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return CUADRILATERO;}

Elipse		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return ELIPSE;}

Circunferencia		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return CIRCUNFERENCIA;}

Parabola		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return PARABOLA;}

Hiperbola		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return HIPERBOLA;}

Poliedro		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return POLIEDRO;}

Cilindro		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return CILINDRO;}

Cono		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return CONO;}

Esfera		{fprintf(file, "<palabra_reservada> %s\n", yytext);
									return ESFERA;}

NEGRO|AZUL|CIAN|GRIS|VERDE|MAGENTA|NARANJA|ROSADO|ROJO|BLANCO|AMARILLO       {fprintf(file, "<palabra_reservada> %s\n", yytext );
																				return COLOR_PREDEF;}

{ID}        {fprintf(file, "<identificador> %s\n", yytext );
				return ID; }

"=" 	{fprintf(file,"<asignacion>: %s\n", yytext );
			return yytext[0]; }

"+"|"-"|"*"|"/"   {fprintf(file, "<operador> %s\n", yytext );
						return yytext[0]; }
"{"|"}"|";"|","|"("|")"   {fprintf(file, "<delimitador> %s\n", yytext);
							return yytext[0]; }

"\n"		{ line++;}   /* count lines */ 

[ \t]+          /* eat up whitespace */

.           fprintf(file, "<caracter_invalido> %s\n", yytext );

%%
