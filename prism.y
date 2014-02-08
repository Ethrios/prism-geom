%{
    #include <stdio.h>
    #include <QDebug>
    #include <QString>
    #include <QHash>
    #include "ast.h"

    //FLEX + BISON variables
    extern int yylex();
    extern char*yytext;
    extern int yyparse();
    extern FILE *yyin;
    extern int line;

    void check_or_insert(QString,Identifier::ID_TYPE);

    //QT interface variable;
    QString syntax;

    //Error handling function
    void yyerror(const char *s) { syntax+=s; }

    //ast root
    Root *root;

    //symbol table
    QHash<QString,Identifier*> symbols;
%}

%union{
        float fval;
        QString* string;
        std::vector<Sentence*>* sentence_list;
        Sentence* sentence;
        Declaration* declaration;
        Asignation* asignation;
        Function* function;
        Draw* draw;
        Background* background;
        Fill* fill;
        Rotate* rotate;
        Translate* translate;
        Scale* scale;
        Param* param;
        Vect* vect;
        Vect2d* vect2d;
        Vect3d* vect3d;
        Color * color;
        Expresion* expresion;
}

%token INICIO FIN 
%token DIBUJAR RELLENAR ROTAR TRASLADAR ESCALAR SOBRE FONDO
%token <fval>PTO_FLOT
%token COLOR VECT2D VECT3D FLOTANTE
%token PUNTO RECTA CURVA PLANO TRIANGULO CUADRILATERO 
%token ELIPSE CIRCUNFERENCIA PARABOLA HIPERBOLA 
%token POLIEDRO CILINDRO CONO ESFERA 
%token <string>COLOR_PREDEF
%token <string>ID

%type <sentence_list>Lista_Sentencias
%type <sentence>Sentencia
%type <declaration>Declaracion
%type <asignation>Asignacion
%type <function> Funcion
%type <param> Param;
%type <vect2d> Vect2d
%type <vect3d> Vect3d
%type <color> Color
%type <draw>Dibujar
%type <fill> Rellenar
%type <rotate> Rotar
%type <scale> Escalar
%type <translate> Trasladar
%type <expresion> Expresion

%start Programa

%% 

Programa : INICIO Lista_Sentencias FIN  {root = new Root($2); syntax+="\nSyntax Correct\n";}
; 

Lista_Sentencias : Sentencia    {$$ = new std::vector<Sentence*>(); $$->push_back($1);}
      | Lista_Sentencias Sentencia  {$$->push_back($2);} //push lista de parametros
; 

Sentencia : Declaracion ';' {$$ = $1;}
                |	Asignacion ';' {$$ = $1;}
                |	Funcion ';' { $$ = $1; }
; 

Declaracion : FLOTANTE ID PTO_FLOT {$$ = new FloatDeclaration($2,$3);
                                    check_or_insert(*$2,Identifier::FLOAT);
                                   }
                |VECT2D ID Vect2d {$$ = new Vect2dDeclaration($2,$3);}
                |VECT3D ID Vect3d {$$ = new Vect3dDeclaration($2,$3);}
                |COLOR ID Color {$$ = new ColorDeclaration($2,$3);}
                |PUNTO ID '{' Param '}' {$$ = new PointDeclaration($2,$4);}
                |RECTA ID '{' Param ',' Param '}' {$$ = new RectDeclaration($2,$4,$6); }
                |CURVA ID '{' '}' {$$ = new Declaration; }
                |PLANO ID '{' '}' {$$ = new Declaration; }
                |TRIANGULO ID '{' Param ',' Param ',' Param '}' {$$ = new Declaration; }
                |CUADRILATERO ID '{' '}' {$$ = new Declaration; }
                |ELIPSE ID '{' '}' {$$ = new Declaration; }
                |CIRCUNFERENCIA ID '{' Param ',' Param '}' {$$ = new Declaration; }
                |PARABOLA ID '{' '}' {$$ = new Declaration; }
                |HIPERBOLA ID '{' '}' {$$ = new Declaration; }
                |POLIEDRO ID '{' '}' {$$ = new Declaration; }
                |CILINDRO ID '{' '}' {$$ = new Declaration; }
                |CONO ID '{' '}' {$$ = new Declaration; }
                |ESFERA ID '{' Param ',' Param '}' {$$ = new Declaration; }
;

Asignacion : ID '=' Expresion {$$ = new Asignation($1,$3);}
; 

Expresion : Param {$$ = new ParamExpresion($1);}
            |Param '+' Param {$$ = new Plus($1,$3);
                                if($1->type != $3->type){yyerror("Error: Los parametros de la suma no concuerdan");} }
            |Param '-' Param {$$ = new Less($1,$3);
                                if($1->type != $3->type){yyerror("Error: Los parametros de la resta no concuerdan");} }
            |Param '*' Param {$$ = new Times($1,$3);
                                if($1->type != $3->type){yyerror("Error: Los parametros de la multiplicacion concuerdan");} }
            |Param '/' Param {$$ = new Division($1,$3);
                                if($1->type != $3->type){yyerror("Error: Los parametros de la division no concuerdan");} }
;

Param : Color {$$= new ColorParam($1);}
        |PTO_FLOT {$$= new FloatParam($1);}
        | Vect2d {$$= new Vect2dParam($1);}
        | Vect3d {$$= new Vect3dParam($1);}
        | ID {$$= new IdParam($1);}
;

Funcion : Dibujar {$$=$1;}
                |Rellenar {$$=$1;}
                |Rotar {$$=$1;}
                |Trasladar {$$=$1;}
                |Escalar {$$=$1;}
                |FONDO Param {$$= new Background($2);}
;

Dibujar : DIBUJAR ID COLOR Param { $$ = new Draw($2,$4);}
;

Rellenar : RELLENAR ID COLOR Param { $$ = new Fill($2,$4);}
;

Rotar : ROTAR ID SOBRE Param Param { $$ = new Rotate($2,$4,$5);}
;

Escalar : ESCALAR ID Param { $$ = new Scale($2,$3);}
;

Trasladar : TRASLADAR ID Param { $$ = new Translate($2,$3);}
;

Color : '(' PTO_FLOT ',' PTO_FLOT ',' PTO_FLOT ',' PTO_FLOT ')' {$$=new Color($2,$4,$6,$8);}
                |COLOR_PREDEF {$$=new Color($1);}
;

Vect2d: '(' PTO_FLOT ',' PTO_FLOT ')' {$$=new Vect2d($2,$4);}
;

Vect3d: '(' PTO_FLOT ',' PTO_FLOT ',' PTO_FLOT ')' {$$=new Vect3d($2,$4,$6);}

         
%% 

void check_or_insert(QString name,Identifier::ID_TYPE t){
    if(symbols.contains(name))
    {
        yyerror("ERROR: Variable ya declarada" );
    }
    else
    {
        symbols.insert(name,new Identifier(name,t));
    }
}

int yywrap()  
{  
   return 1;  
}  

 

