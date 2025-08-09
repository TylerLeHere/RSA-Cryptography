#ifndef CONFIG_H
#define CONFIG_H
#include <stdint.h>

// Some basic defines for config
#define u32 __uint32_t
#define u64 __uint64_t
#define R_POWER 32

#define ENCRYPT rsa_modexp_encrypt
#define DECRYPT rsa_modexp_decrypt

#endif
