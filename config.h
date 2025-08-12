#ifndef CONFIG_H
#define CONFIG_H
#include <stdint.h>

// Some basic defines for config
#define u32 __uint32_t
#define u64 __uint64_t
#define R_POWER 32
#define R_POWER_LOG 5 // log2(R_POWER)

#define ENCRYPT rsa_montgomery_encrypt
#define DECRYPT rsa_montgomery_decrypt

// toggle debug comments off and on by commenting out the below line
// #define DEBUG_BUILD

#ifdef DEBUG_BUILD
#define DEBUG(...) printf(__VA_ARGS__)
#else
#define DEBUG(...) (void)0
#endif


//#define LUT_ENABLED

#endif
