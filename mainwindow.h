#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QDebug>
#include <QProcess>
#include <QString>
#include <QStringList>
#include <QDesktopServices>
#include <QUrl>
#include <string>

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_startNodeButton_clicked();

    void on_stopNodeButton_clicked();

    void on_feeAddressAmount_valueChanged(int arg1);

private:
    Ui::MainWindow *ui;
//    std::to_string(valFeeAddressAmount);
};

#endif // MAINWINDOW_H
