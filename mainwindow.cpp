#include "mainwindow.h"
#include "ui_mainwindow.h"

#include<stdio.h>
#include<QDebug>
#include<iostream>

    extern int yyparse();
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    extern FILE *file;
    extern int line;
    extern QString output;

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}



void MainWindow::on_actionNuevo_triggered()
{
    mArchivo = "";
    ui->textEdit->setPlainText("");
}

void MainWindow::on_actionAbrir_triggered()
{
    QString archivo = QFileDialog ::getOpenFileName(this,"Abrir un Archivo");

    if(!archivo.isEmpty())
    {
        QFile sArchivo(archivo);
        if(sArchivo.open(QFile::ReadOnly | QFile::Text))
        {
            mArchivo = archivo;
            QTextStream in(&sArchivo);
            QString text = in.readAll();
            sArchivo.close();
            ui->textEdit->setPlainText(text);
        }
    }
}


void MainWindow::on_pushButton_clicked()
{

    //guarda el archivo editado antes de intentar analizar

    on_actionGuardar_triggered();


    //abre el archivo de nuevo y lo manda al yylex

    file = fopen("output.txt", "w+");
    if (!file) {
        qDebug()<<"ERROR: Can't open file!\n";
        return;
    }

    yyin = fopen(mArchivo.toLocal8Bit().data(), "r" );

    do {
        yyparse();
    } while (!feof(yyin));

    ui->analizado->clear();
    ui->analizado->setPlainText(output);
    output.clear();


}



void MainWindow::on_actionGuardar_triggered()
{
    if(mArchivo == ""){
        on_actionGuardar_Como_triggered();
    }
    else{
        QFile sArchivo(mArchivo);
        if(sArchivo.open(QFile::WriteOnly | QFile::Text))
        {
            QTextStream salida(&sArchivo);
            salida << ui->textEdit->toPlainText();
            sArchivo.flush();
            sArchivo.close();
        }
    }
}

void MainWindow::on_actionCerrar_triggered()
{
    close();
}

void MainWindow::on_actionCopiar_triggered()
{
    ui->textEdit->copy();
}

void MainWindow::on_actionCortar_triggered()
{
    ui->textEdit->cut();
}

void MainWindow::on_actionPegar_triggered()
{
    ui->textEdit->paste();
}

void MainWindow::on_actionGuardar_Como_triggered()
{
    QString archivo = QFileDialog ::getSaveFileName(this,"Guardar el Archivo");

    if(!archivo.isEmpty())
    {
        mArchivo = archivo;
        on_actionGuardar_triggered();

    }
}
