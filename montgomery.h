#ifndef MONTGOMERY_H
#define MONTGOMERY_H

#include "config.h"

// Convert to montgomery domain
// Param x: The number to convert to montgomery space
// Param n: The modulus that we are converting to montgomery space for
static inline u32 montgomery_transform(u32 x, u32 n) {
  // x_bar = x * R mod N
  u64 temp_result = (u64)x << R_POWER;
  return (u32)(temp_result % n);
}



static inline u32 find_n_prime(u32 n) {
  // this is really inefficient rn, theres definitely WAYYY better ways to do
  // this Just trying to get it functional before I optimize

  u32 n_prime = 1;

  for (int i = 0; i < R_POWER_LOG; ++i) {
    n_prime *= 2 - n * n_prime;
  }

  return n_prime;
}

// RSA encryption using montgomery multiplication
// C = data^E mod PQ
u32 rsa_montgomery_encrypt(u32 data, u32 PQ, u32 E);

// RSA decryption using montgomery multiplication
u32 rsa_montgomery_decrypt(u32 data, u32 PQ, u32 D);

u32 montgomery_reduce(u64 x, u32 n_prime, u32 n);



#endif
