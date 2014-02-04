%{
    #include <stdio.h>
    #include <QDebug>
    void yyerror(const char *s) { qDebug()<<"ERROR:"<<s; }

    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    extern FILE *file;
    extern int line;
%}

%union{
        float fval;
		  char* cval;
}

%token INICIO FIN 
%token DIBUJAR RELLENAR ROTAR TRASLADAR ESCALAR SOBRE FONDO
%token <fval>PTO_FLOT
%token COLOR VECT2D VECT3D FLOTANTE
%token PUNTO RECTA CURVA PLANO TRIANGULO CUADRILATERO 
%token ELIPSE CIRCUNFERENCIA PARABOLA HIPERBOLA 
%token POLIEDRO CILINDRO CONO ESFERA 
%token <cval>COLOR_PREDEF
%token <cval>ID

%start Programa

%% 

Programa : INICIO Lista_Sentencias FIN  {qDebug()<<"\nCORRECT SYNTAX\n";}
; 

Lista_Sentencias : Sentencia
      | Lista_Sentencias Sentencia 
; 

Sentencia : Declaracion ';'
		|	Asignacion ';'
		|	Funcion ';'
; 

Declaracion : FLOTANTE ID PTO_FLOT 
		|VECT2D ID Vect2d
		|VECT3D ID Vect3d
		|COLOR ID Color
		|Tipo_De_Dato ID '{' Lista_Param '}'  
;                

Lista_Param : //vacio
		|Lista_Param ',' Param
		|Param 
; 

Param : Vect2d
		| Vect3d
		| PTO_FLOT
		| ID
;

Asignacion : ID '=' Expresion
; 

Expresion : Operando Op Operando
		| Operando
;

Operando : Color 
		| PTO_FLOT
		| Vect2d
		| Vect3d
;

Op : '+'
		|'-'
		|'*'
		|'/'
;

Tipo_De_Dato : PUNTO
		|RECTA
		|CURVA
		|PLANO
		|TRIANGULO
		|CUADRILATERO
		|ELIPSE
		|CIRCUNFERENCIA
		|PARABOLA
		|HIPERBOLA
		|POLIEDRO
		|CILINDRO
		|CONO
		|ESFERA
;

Funcion : Dibujar
		|Rellenar
		|Rotar
		|Trasladar
		|Escalar
;

Dibujar : DIBUJAR ID COLOR Color
		| DIBUJAR ID COLOR ID
		| DIBUJAR FONDO Color
		| DIBUJAR FONDO ID
;

Rellenar : RELLENAR ID COLOR Color
		| RELLENAR ID COLOR ID
;

Rotar : ROTAR ID SOBRE Vector PTO_FLOT
		|ROTAR ID SOBRE Vector ID
		|ROTAR ID SOBRE ID ID
;

Escalar : ESCALAR ID Vector
		|ESCALAR ID ID
;

Trasladar : TRASLADAR ID Vector
		| TRASLADAR ID ID
;

Vector : Vect2d
		|Vect3d
;

Color : '(' PTO_FLOT ',' PTO_FLOT ',' PTO_FLOT ',' PTO_FLOT ')'
		|COLOR_PREDEF
;

Vect2d: '(' PTO_FLOT ',' PTO_FLOT ')'
;

Vect3d: '(' PTO_FLOT ',' PTO_FLOT ',' PTO_FLOT ')'

         
%% 


int yywrap()  
{  
   return 1;  
}  

 

