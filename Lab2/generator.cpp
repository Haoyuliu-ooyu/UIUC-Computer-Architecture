// a code generator for the ALU chain in the 32-bit ALU
// look at example_generator.cpp for inspiration
#include <cstdio>
using std::printf;

int
main() {
    int width = 32;
    for (int i = 1; i < width; i++) {
        printf(  "dffe d%d(q[%d], d[%d], clk, enable, reset);\n", i, i, i);
    }
}

// make generator module dffe(q, d, clk, enable, reset);
// ./generator
