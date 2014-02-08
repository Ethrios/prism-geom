#ifndef AST_H
#define AST_H

#include<vector>
#include<QString>

class Identifier{
public:
    enum ID_TYPE{FLOAT,VECT2,VECT3,COLOR,POINT,RECT,CURVE,PLANE,TRIANGLE,QUAD,ELIPSE,CIRC,PARABOLE,HYPERBOLE,
                 POLYHEDRON,CONE,SPHERE};
    Identifier(QString name,ID_TYPE t){this->name=name;this->type=t;}
    ID_TYPE type;
    QString name;
    QString type_string(){
        switch (type) {
        case Identifier::FLOAT:
            return "Flotante";
        case Identifier::VECT2:
            return "Vector2d";
        case Identifier::VECT3:
            return "Vector3d";
        case Identifier::COLOR:
            return "Color";
        case Identifier::POINT:
            return "Punto";
        case Identifier::RECT:
            return "Recta";
        case Identifier::CURVE:
            return "Curva";
        case Identifier::PLANE:
            return "Plano";
        case Identifier::TRIANGLE:
            return "Triangulo";
        case Identifier::QUAD:
            return "Cuadrilatero";
        case Identifier::ELIPSE:
            return "Elipse";
        case Identifier::CIRC:
            return "Circunferencia";
        case Identifier::PARABOLE:
            return "Parabola";
        case Identifier::HYPERBOLE:
            return "Hiperbola";
        case Identifier::POLYHEDRON:
            return "Poliedro";
        case Identifier::CONE:
            return "Cono";
        case Identifier::SPHERE:
            return "Esfera";
        default:
            return "ERROR EN EL TIPO DE DATO";
        }

    }
};

//BASIC DATA TYPE CLASSES

class Vect{};

class Vect2d : public Vect{
public:
    Vect2d(float x,float y){this->x=x;this->y=y;}
    float x;
    float y;
};

class Vect3d : public Vect{
public:
    Vect3d(float x,float y,float z){this->x=x;this->y=y;this->z=z;}
    float x;
    float y;
    float z;
};

class Color{
public:
    Color(float r,float g,float b,float a){this->red=r;this->green=g;this->blue=b;this->alpha=a;}
    Color(QString* c)
    {
        if(c)
            this->alpha=0;

    }
    float red;
    float green;
    float blue;
    float alpha;
};

class Param{
public:
    enum PARAM_TYPE{FLOAT,VECT2D,VECT3D,ID,COLOR};
    PARAM_TYPE type;
};

class Vect2dParam : public Param{
public:
    Vect2dParam(Vect2d* v){this->v2d=v;type=Param::VECT2D;}
    Vect2d* v2d;
};

class Vect3dParam : public Param{
public:
    Vect3dParam(Vect3d* v){this->v3d=v;type=Param::VECT3D;}
    Vect3d* v3d;

};

class IdParam : public Param{
public:
    IdParam(QString* id){this->id=id;type=Param::ID;}
    QString* id;
};

class FloatParam : public Param{
public:
    FloatParam(float f){this->f=f;type=Param::FLOAT;}
    float f;
};

class ColorParam : public Param{
public:
    ColorParam(Color* c){this->color = c;type=Param::COLOR;}
    Color* color;
};


//ROOT CLASS

class Sentence{
};

class Root {
public:
    Root(std::vector<Sentence*>* list){this->sentence_list=list;}
    std::vector<Sentence*> *sentence_list;
};




//DECLARATION CLASSES:


class Declaration : public Sentence{
public:
    QString* id;
};


class FloatDeclaration : public Declaration{
public:
    FloatDeclaration(QString*id,float fval){this->f=fval;this->id=id;}
    float f;
};

class Vect2dDeclaration : public Declaration{
public:
    Vect2dDeclaration(QString*id,Vect2d *v2d){this->id=id;this->v2d=v2d;}
    Vect2d *v2d;
};

class Vect3dDeclaration : public Declaration{
public:
    Vect3dDeclaration(QString*id,Vect3d *v3d){this->id=id;this->v3d=v3d;}
    Vect3d *v3d;
};

class ColorDeclaration : public Declaration{
public:
    ColorDeclaration(QString*id,Color *c){this->id=id;this->color=c;}
    Color *color;
};

class PointDeclaration : public Declaration{
public:
    PointDeclaration(QString*id,Param* p){this->id=id;this->p=p;}
    Param* p;
};

class RectDeclaration : public Declaration{
public:
    RectDeclaration(QString*id,Param *a,Param *b){this->id=id;this->a=a;this->b=b;}
    Param *a;
    Param *b;
};



//ASIGNATION CLASSES

class Expresion{
};

class Asignation : public Sentence{
public:
    Asignation(QString*id,Expresion* exp){this->id=id;this->exp=exp;}
    QString* id;
    Expresion *exp;
};

class ParamExpresion : public Expresion{
public:
    ParamExpresion(Param* p){this->p=p;}
    Param* p;
};

class Plus : public Expresion{
public:
    Plus(Param *a,Param* b){this->a=a;this->b=b;}
    Param* a;
    Param* b;
};

class Less : public Expresion{
public:
    Less(Param *a,Param* b){this->a=a;this->b=b;}
    Param* a;
    Param* b;
};

class Times : public Expresion{
public:
    Times(Param *a,Param* b){this->a=a;this->b=b;}
    Param* a;
    Param* b;
};

class Division : public Expresion{
public:
    Division(Param *a,Param* b){this->a=a;this->b=b;}
    Param* a;
    Param* b;
};

//FUNCTION CLASSES

class Function : public Sentence{
};

class Draw : public Function{
public:
    Draw(QString*id,Param* c){this->id=id;this->color=c;}
    QString*id;
    Param* color;
};

class Background : public Function{
public:
    Background(Param* c){this->color=c;}
    Param* color;
};

class Fill : public Function{
public:
    Fill(QString*id,Param* c){this->id=id;this->color=c;}
    QString*id;
    Param* color;
};

class Translate : public Function{
public:
    Translate(QString*id,Param* v){this->id=id;this->vect=v;}
    QString*id;
    Param* vect;
};

class Rotate : public Function{
public:
    Rotate(QString*id,Param* ax,Param *an){this->id=id;this->axis=ax;this->angle=an;}
    QString*id;
    Param* axis;
    Param* angle;
};

class Scale : public Function{
public:
    Scale(QString*id,Param* v){this->id=id;this->vect=v;}
    QString*id;
    Param* vect;
};





#endif // AST_H
