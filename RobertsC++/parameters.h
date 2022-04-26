#pragma once
#include <cstdint>

struct Parameters {
	uint8_t* inputData, * outputData; 
	int startY, size, width;
};