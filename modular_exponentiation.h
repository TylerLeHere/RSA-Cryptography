#ifndef MODULAR_EXPONENTIATION_H
#define MODULAR_EXPONENTIATION_H

#include "config.h"

// RSA encryption: C = data^E mod PQ
u32 rsa_modexp_encrypt(u32 data, u32 PQ, u32 E);

// RSA decryption: M = data^D mod PQ
u32 rsa_modexp_decrypt(u32 data, u32 PQ, u32 D);

#endif
