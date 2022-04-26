#pragma once

#include <QtWidgets/QMainWindow>
#include <QFileDialog>
#include <vector>
#include <thread>
#include <sstream>
#include <chrono>
#include <memory>
#include <windows.h>
#include "ui_RobertsCross.h"
#include "parameters.h"

typedef void(__cdecl* CROSS)(Parameters*);

class RobertsCross : public QMainWindow
{
    Q_OBJECT

public:
    RobertsCross(QWidget *parent = Q_NULLPTR);

private:
    Ui::RobertsCrossClass ui;
    QImage inputImg;
    std::vector<uint8_t> processPixels, outPixels;
    void retrieveOutputImage();
    void retrieveProcessPixels();
private slots:
    void loadImg();
    void process();

};
