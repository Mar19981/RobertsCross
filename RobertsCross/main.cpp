#include "RobertsCross.h"
#include <QtWidgets/QApplication>
#include <QMessageBox>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    RobertsCross w;
    try {
        w.show();
        return a.exec();
    }
    catch (std::exception& e) {
        QMessageBox::warning(&w, "Warning", e.what());
        return a.exec();
    }
}
