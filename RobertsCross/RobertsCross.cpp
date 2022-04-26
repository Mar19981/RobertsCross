#include "RobertsCross.h"

RobertsCross::RobertsCross(QWidget *parent)
    : QMainWindow(parent)
{
    ui.setupUi(this);
    auto sizeHint = this->sizeHint() * 2;
    auto viewSize = QSize(sizeHint.width() >> 2, sizeHint.width() >> 2);
    this->setFixedSize(sizeHint);
    ui.input->setFixedSize(viewSize);
    ui.output->setFixedSize(viewSize);
    ui.results->setFixedSize(viewSize.width(), viewSize.height());
    ui.threads->setValue(std::thread::hardware_concurrency());
    connect(ui.pushButton, SIGNAL(clicked()), this, SLOT(loadImg()));
    connect(ui.computeButton, SIGNAL(clicked()), this, SLOT(process()));

}
void RobertsCross::loadImg() {
    auto path = QFileDialog::getOpenFileName(this, "Wybierz plik", QDir::homePath(), "*.jpg *.bmp *.png");
    if (path.isNull() || path.isEmpty()) return;
    inputImg = QImage(path);
    ui.input->setPixmap(QPixmap::fromImage(inputImg).scaled(ui.input->size(), Qt::AspectRatioMode::KeepAspectRatio));

}

void RobertsCross::retrieveOutputImage()
{
    int width = inputImg.width(), height = inputImg.height();
    QImage out{ width, height, inputImg.format() };
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int lightness = outPixels.at(y * width + x);
            QColor color = QColor(lightness, lightness, lightness);
            out.setPixelColor(x, y, color);
        }
    }
    ui.output->setPixmap(QPixmap::fromImage(out).scaled(ui.output->size(), Qt::AspectRatioMode::KeepAspectRatio));
}

void RobertsCross::retrieveProcessPixels()
{
    int width = inputImg.width(), height = inputImg.height();
    processPixels.resize(width * height);
    outPixels.resize(width * height);
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {

            auto color = inputImg.pixelColor(x, y);
            processPixels.at(y * width + x) = outPixels.at(y * width + x) = color.lightness();
        }
    }
}

void RobertsCross::process()
{
    if (inputImg.isNull()) throw std::runtime_error("Please load image");
    retrieveProcessPixels();
    int threadNumber = ui.threads->value(), dividedPixels{},
        height = inputImg.height() - 1, width = inputImg.width() - 1, yStep = height / threadNumber,
        processSize = width * height,
        step = processSize / threadNumber, y = 1;
    std::vector<std::thread> threads( threadNumber );
    std::vector<std::unique_ptr<Parameters>> params( threadNumber );

    HINSTANCE hDll{};
    CROSS functionPtr{};

    hDll = LoadLibrary(ui.cppRadio->isChecked() ? TEXT("RobertsC++.dll") : TEXT("RobertsAsm.dll"));
    if (!hDll) throw std::runtime_error("Failed to load library");
    functionPtr = (CROSS)GetProcAddress(hDll, "robertsCross");
    if (!functionPtr) throw std::runtime_error("Failed to load function");

    for (int i = 0; i < threadNumber - 1; i++) {
        params.at(i) = std::make_unique<Parameters>();
        params.at(i)->inputData = processPixels.data();
        params.at(i)->outputData = outPixels.data();
        params.at(i)->startY = y;
        params.at(i)->size = step;
        params.at(i)->width = width;
        dividedPixels += step;
        y += yStep;
    }

    params.at(threadNumber - 1) = std::make_unique<Parameters>();
    params.at(threadNumber - 1)->inputData = processPixels.data();
    params.at(threadNumber - 1)->outputData = outPixels.data();
    params.at(threadNumber - 1)->startY = y;
    params.at(threadNumber - 1)->size = processSize - step * (threadNumber - 1);
    params.at(threadNumber - 1)->width = width;

    for (int i = 0; i < threadNumber; i++)
        threads.at(i) = std::thread(functionPtr, params.at(i).get());

    auto t1 = std::chrono::high_resolution_clock::now();
    for (auto& thread : threads)
        if (thread.joinable()) thread.join();
    auto t2 = std::chrono::high_resolution_clock::now();
    std::stringstream ss;
    ss << "Rozmiar: " << inputImg.width() << "x" << inputImg.height() << "\tBiblioteka: "
        << (ui.cppRadio->isChecked() ? "C++" : "Asembler") << "\tWatki: " << threadNumber << "\tCzas: " << std::chrono::duration<double, std::milli>(t2 - t1).count() << "ms\n\n";
    ui.results->setPlainText(ui.results->toPlainText() + ss.str().c_str());
    FreeLibrary(hDll);
    retrieveOutputImage();
}
