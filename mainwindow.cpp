#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QDesktopServices>
#include <QUrl>
#include <QString>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    qDebug() << "[EVENT] Window drawn!";
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::on_startNodeButton_clicked()
{
    qDebug() << "[EVENT] startNodeButton clicked!";
    QProcess *process = new QProcess();
        QString program = "TurtleCoind.exe";
        QStringList arguments;
        arguments << "--fee-amount" << valFeeAddressAmount << "--fee-address" << "TRTLuxEnfjdF46cBoHhyDtPN32weD9fvL43KX5cx2Ck9iSP4BLNPrJY3xtuFpXtLxiA6LDYojhF7n4SwPNyj9M64iTwJ738vnJk";
        process->start(program, arguments);
        qDebug() << "[EVENT] TurtleCoind.exe has launched";
}

void MainWindow::on_stopNodeButton_clicked()
{
    qDebug() << "[EVENT] Kill signal received!";
    QApplication::quit();
}

void MainWindow::on_feeAddressAmount_valueChanged(int arg1)
{
    qDebug() << "[EVENT] Fee amount assigned";
    int valFeeAddressAmount = ui->feeAddressAmount->text().toInt();
}
