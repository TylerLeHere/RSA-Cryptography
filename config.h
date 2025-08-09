#ifndef CONFIG_H
#define CONFIG_H
#include <stdint.h>

// Some basic defines for config
#define u32 __uint32_t
#define u64 __uint64_t
#define R_POWER 32
#define R_POWER_LOG 5 // log2(32) for determining N'

#define ENCRYPT rsa_montgomery_encrypt
#define DECRYPT rsa_montgomery_decrypt

#endif
