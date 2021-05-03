#pragma once

#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/functional.h>
#include <stdio.h>
#include <iostream>
#include <vector>
#include <sstream>
#include <stdlib.h>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "wb.h"
#include "lab_utils.h"


using namespace std;
using namespace thrust;

/*
    https://docs.nvidia.com/cuda/archive/9.0/pdf/Thrust_Quick_Start_Guide.pdf
*/
static int run_thrust_vector_add(int argc, char* argv[]) {
    wbArg_t args;
    float* hostInput1 = nullptr;
    float* hostInput2 = nullptr;
    float* hostOutput = nullptr;
    int inputLength;
    cudaError_t cudaStatus;

    args = wbArg_read(argc, argv); /* чтение входных аргументов */

    cudaStatus = cudaSetDevice(0);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
        free(hostInput1);
        free(hostInput2);
        free(hostOutput);
        throw std::runtime_error(std::string("No CUDA compatible device found "));
    }
    
    // Импорт входных данных на хост
    wbTime_start(Generic, "Importing data to host");
    int s1 = 0;
    hostInput1 = read_float(argv[1], &s1);
    int s2 = 0;
    hostInput2 = read_float(argv[2], &s2);;
    inputLength = min(s1, s2);

    std::string m1 = "vector #1:";
    print_float(&m1, hostInput1, &inputLength);
    std::string m2 = "vector #2:";
    print_float(&m2, hostInput2, &inputLength);
    wbTime_stop(Generic, "Importing data to host");

    // Объявление и выделение памяти под выходные данные
    thrust::device_vector<float> deviceOutput(inputLength);
    thrust::host_vector<float> h_output(inputLength);

    wbTime_start(GPU, "Doing GPU Computation (memory + compute)");

    // Объявление и выделение памяти под входные и выходные данные  на устройства через thrust
    wbTime_start(GPU, "Doing GPU memory allocation");
    thrust::host_vector<float> h_input1(inputLength);
    thrust::host_vector<float> h_input2(inputLength);
    for (int i = 0; i < inputLength; i++) {
        h_input1[i] = hostInput1[i];
        h_input2[i] = hostInput2[i];
    }
    thrust::device_vector<float> deviceInput1(inputLength);
    thrust::device_vector<float> deviceInput2(inputLength);




    wbTime_stop(GPU, "Doing GPU memory allocation");

    // Копирование на устройство
    wbTime_start(Copy, "Copying data to the GPU");

    thrust::copy(h_input1.begin(), h_input1.end(), deviceInput1.begin());
    thrust::copy(h_input2.begin(), h_input2.end(), deviceInput2.begin());
       
    wbTime_stop(Copy, "Copying data to the GPU");

    // Выполнение операции сложения векторов
    wbTime_start(Compute, "Doing the computation on the GPU");
    thrust::transform(deviceInput1.begin(), deviceInput1.end(), deviceInput2.begin(), deviceOutput.begin(), thrust::plus<float>());
    wbTime_stop(Compute, "Doing the computation on the GPU");
    /////////////////////////////////////////////////////////

    // Копирование данных обратно на хост
    wbTime_start(Copy, "Copying data from the GPU");
    thrust::copy(deviceOutput.begin(), deviceOutput.end(), h_output.begin());
    hostOutput = new float[h_output.size()];
    for (int i = 0; i < h_output.size(); i++) {
        hostOutput[i] = h_output[i];
    }
    wbTime_stop(Copy, "Copying data from the GPU");

    wbTime_stop(GPU, "Doing GPU Computation (memory + compute)");
    
    std::string r = "result vector:";
    print_float(&r, hostOutput, &inputLength);
    //wbSolution(args, hostOutput, inputLength);

    cudaFree(&deviceInput1);
    cudaFree(&deviceInput2);
    cudaFree(&deviceOutput);
    cudaFree(&h_input1);
    cudaFree(&h_input2);
    cudaFree(&h_output);
    return 0;
    
}

