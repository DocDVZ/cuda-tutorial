//#include <thrust/device_vector.h>
//#include <thrust/host_vector.h>
//#include <thrust/functional.h>
//#include <stdio.h>

//#include "cuda_runtime.h"
//#include "device_launch_parameters.h"
#pragma once
#include "wb.h"

/*
    https://docs.nvidia.com/cuda/archive/9.0/pdf/Thrust_Quick_Start_Guide.pdf
*/
static int run_thrust_vector_add(int argc, char* argv[]) {
    wbArg_t args;
    float* hostInput1 = nullptr;
    float* hostInput2 = nullptr;
    float* hostOutput = nullptr;
  //  cudaError_t cudaStatus;

    args = wbArg_read(argc, argv); /* чтение входных аргументов */

  //  cudaStatus = cudaSetDevice(0);
  //  if (cudaStatus != cudaSuccess) {
  //      fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
  //      return cudaStatus;
  //  }
    return 0;
    /*
    // Импорт входных данных на хост
    wbTime_start(Generic, "Importing data to host");
    hostInput1 =
        (float*)wbImport(wbArg_getInputFile(args, 0), &inputLength);
    hostInput2 =
        (float*)wbImport(wbArg_getInputFile(args, 1), &inputLength);
    wbTime_stop(Generic, "Importing data to host");

    // Объявление и выделение памяти под выходные данные
    int floatSize = sizeof(float);
    float *d_output;
    cudaMalloc((void**)&d_output, floatSize);

    cudaMalloc((void**)&hostOutput, sizeof(float));
    //thrust::device_ptr<float> deviceOutputPtr(&hostOutput);
    thrust::device_vector<float> deviceOutput(1);

    wbTime_start(GPU, "Doing GPU Computation (memory + compute)");

    // Объявление и выделение памяти под входные и выходные данные  на устройства через thrust
    wbTime_start(GPU, "Doing GPU memory allocation");
    thrust::device_vector<float> deviceInput1(1);
    thrust::device_vector<float> deviceInput2(1);


    wbTime_stop(GPU, "Doing GPU memory allocation");

    // Копирование на устройство
    wbTime_start(Copy, "Copying data to the GPU");
    float *d_input1, *d_input2;
    cudaMalloc((void**)&d_input1, floatSize);
    cudaMemcpy(d_input1, hostInput1, floatSize, cudaMemcpyHostToDevice);
    cudaMalloc((void**)&d_input2, floatSize);
    cudaMemcpy(d_input2, hostInput1, floatSize, cudaMemcpyHostToDevice);
    //thrust::fill(deviceInput1.begin(), deviceInput1.end(), &d_input1);
    //thrust::fill(deviceInput2.begin(), deviceInput2.end(), &d_input2);
    wbTime_stop(Copy, "Copying data to the GPU");

    // Выполнение операции сложения векторов
    wbTime_start(Compute, "Doing the computation on the GPU");
    thrust::transform(deviceInput1.begin(), deviceInput1.end(), deviceInput2.begin(), deviceOutput.begin(), thrust::plus<float>());
    wbTime_stop(Compute, "Doing the computation on the GPU");
    /////////////////////////////////////////////////////////

    // Копирование данных обратно на хост
    wbTime_start(Copy, "Copying data from the GPU");
    thrust::device_reference<float> o = deviceOutput[0];
    d_output = thrust::raw_pointer_cast(&o);
    cudaMemcpy(d_output, hostOutput, floatSize, cudaMemcpyDeviceToHost);
    wbTime_stop(Copy, "Copying data from the GPU");

    wbTime_stop(GPU, "Doing GPU Computation (memory + compute)");

    wbSolution(args, hostOutput, inputLength);

    free(hostInput1);
    free(hostInput2);
    free(hostOutput);
    return 0;
    */

}

