#pragma once
#include <stdio.h>
#include <cuda_runtime.h>

#include "wb.h"
#include "lab_utils.h"

#define FLOAT_SIZE sizeof(float)


__global__ static void vecAdd(float* in1, float* in2, float* out, int len) {
    int i = threadIdx.x;

    if (i < len) {
        out[i] = in1[i] + in2[i];
    }
}

static int vector_add(int argc, char** argv) {
    wbArg_t args;
    int inputLength;
    float* hostInput1;
    float* hostInput2;
    float* hostOutput;


    args = wbArg_read(argc, argv);

    wbTime_start(Generic, "Importing data and creating memory on host");
    //hostInput1 = (float*)wbImport(wbArg_getInputFile(args, 0), &inputLength);
    //hostInput2 = (float*)wbImport(wbArg_getInputFile(args, 1), &inputLength);
    int s1 = 0;
    hostInput1 = read_float(argv[1], &s1);
    int s2 = 0;
    hostInput2 = read_float(argv[2], &s2);;
    inputLength = min(s1, s2);
    std::string m1 = "vector #1:";
    print_float(&m1, hostInput1, &inputLength);
    std::string m2 = "vector #2:";
    print_float(&m2, hostInput2, &inputLength);
    hostOutput = (float*)malloc(inputLength * sizeof(float));

    wbTime_stop(Generic, "Importing data and creating memory on host");

    wbLog(TRACE, "The input length is ", inputLength);

    wbTime_start(GPU, "Allocating GPU memory.");
    float* deviceInput1;
    float* deviceInput2;
    float* deviceOutput;
    // places variables in unified space accesible for both cpu & gpu
    cudaMallocManaged(&deviceInput1, inputLength * FLOAT_SIZE);
    cudaMallocManaged(&deviceInput2, inputLength * FLOAT_SIZE);
    cudaMallocManaged(&deviceOutput, inputLength * FLOAT_SIZE);

    wbTime_stop(GPU, "Allocating GPU memory.");

    wbTime_start(GPU, "Copying input memory to the GPU.");
    for (int i = 0; i < inputLength; i++) {
        deviceInput1[i] = hostInput1[i];
        deviceInput2[i] = hostInput2[i];
        deviceOutput[i] = 0;
    }

    wbTime_stop(GPU, "Copying input memory to the GPU.");

    //@@ Инициализируйте размерности сетки и блоков
    int blocks = 1; // number of thread blocks
    int threads = inputLength; // number of threads within each thread block

    wbTime_start(Compute, "Performing CUDA computation");
    vecAdd <<<blocks, threads>>> (deviceInput1, deviceInput2, deviceOutput, inputLength);

    cudaDeviceSynchronize();
    wbTime_stop(Compute, "Performing CUDA computation");

    wbTime_start(Copy, "Copying output memory to the CPU");
    //cudaMemcpy(hostOutput, deviceOutput, inputLength * FLOAT_SIZE, cudaMemcpyDeviceToHost);
    for (int i = 0; i < inputLength; i++) {
        hostOutput[i] = deviceOutput[i];
    }
    std::string r = "result vector:";
    print_float(&r, hostOutput, &inputLength);
   

    wbTime_stop(Copy, "Copying output memory to the CPU");

    wbTime_start(GPU, "Freeing GPU Memory");
    cudaFree(deviceInput1);
    cudaFree(deviceInput2);
    cudaFree(deviceOutput);

    wbTime_stop(GPU, "Freeing GPU Memory");

    //wbSolution(args, hostOutput, inputLength);

    free(hostInput1);
    free(hostInput2);
    free(hostOutput);

    return 0;
}
