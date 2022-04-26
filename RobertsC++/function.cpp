#include <algorithm>
#include "parameters.h"

void robertsCross(Parameters* params) {
	int y = params->startY;
	for (;;) {
		for (int x = 0; x < params->width; x++) {
			int tmp1 = std::abs(params->inputData[y * params->width + x] - params->inputData[(y + 1) * params->width + x + 1]),
				tmp2 = std::abs(params->inputData[y * params->width + x + 1] - params->inputData[(y + 1) * params->width + x]);
			params->outputData[y * params->width + x] = tmp1 + tmp2;
			params->size--;
			if (!params->size) return;
		}
		y++;
	}
}