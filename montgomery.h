#ifndef MONTGOMERY_H
#define MONTGOMERY_H

#include "config.h"

// Convert to montgomery domain
// Param x: The number to convert to montgomery space
// Param n: The modulus that we are converting to montgomery space for
static inline u32 convert_to_montgomery(u32 x, u32 n) {
  // x_bar = x * R mod N
  u64 temp_result = (u64)x << R_POWER;
  return (u32)(temp_result % n);
}

static inline u32 find_n_prime(u32 N) {
  // this is really inefficient rn, theres definitely WAYYY better ways to do
  // this Just trying to get it functional before I optimize
  int x = 1;
  while (1) {
    if (N * x % (((u64)1 << R_POWER)) ==
        1) { // mod R literally defeats the whole point of montgomery mult,
             // should be using bit ops
      return x;
    }
  }

  return 0;
}

// RSA encryption using montgomery multiplication
// C = data^E mod PQ
u32 rsa_montgomery_encrypt(u32 data, u32 PQ, u32 E);

// RSA decryption using montgomery multiplication
u32 rsa_montgomery_decrypt(u32 data, u32 PQ, u32 D);

#endif
