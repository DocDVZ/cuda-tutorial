#pragma once

#include <vector>
#include <sstream>
#include <iostream>


using namespace std;

static float* read_float(char* chars, int* resultSize) {

    vector<string> strings;
    istringstream is(chars);
    string s;
    while (getline(is, s, ',')) {
        strings.push_back(s);
    }
    int size = strings.size();
    *resultSize = size;
    float* f = new float[size];
    for (int i = 0; i < size; i++) {
        f[i] = std::stof(strings[i]);
    }
    return f;
}

static void print_float(string* str, float* f, int* len) {
    for (int i = 0; i < *len; i++) {
        *str += " ";
        *str += std::to_string(f[i]);
    }
    std::cout << *str << std::endl;
}