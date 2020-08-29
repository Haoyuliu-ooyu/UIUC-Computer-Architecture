/**
 * @file
 * Contains an implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

unsigned char *extractMessage(const unsigned char *message_in, int length) {
    // length must be a multiple of 8
    assert((length % 8) == 0);

    // allocate an array for the output
    unsigned char *message_out = new unsigned char[length];
    for (int i = 0; i < length; i++) {
        message_out[i] = 0;
    }

    // TODO: write your code here
    for (int a = 0; a < length; a+=8) {
        unsigned char filter = 1;
        for (int b = 0; b < length; b++) {
            unsigned char carrier = 0;
            for (int c = 7; c >= 0; c--) {
                unsigned char fancyWords = message_in[a + c];
                unsigned fancyWord = (fancyWords & filter) >> b;
                carrier += fancyWord << c;
            }
            message_out[a + b] = carrier;
            filter = filter << 1;
        }
    }

    return message_out;
}
