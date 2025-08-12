#ifndef MONTGOMERY_H
#define MONTGOMERY_H

#include "config.h"

// Converts a number to montgomery space
static inline u32 montgomery_transform(u32 x, u32 n) {
  // x_bar = x * R mod N
  u64 temp_result = (u64)x << R_POWER;
  return (u32)(temp_result % n);
}

// find n' s.t   r*(r^-1) + n*n' = 1
// based off Dusse and Kaliski jr for uneven n
static inline u32 find_n_prime(u32 n) {
  // y = 1
  // for i = 2 to R_POWER_LOG do
  //  if (n*y mod 2i) then
  //    y = y+ 2^(i-1)
  // return r -y
  asm volatile("# find_n_prime start");
  u32 y = 1;
  for (int i = 2; i <= R_POWER; ++i) {
    if ((((u64)n * y) & ((1ULL << i) - 1)) != 1) {
      y += 1U << (i - 1);
    }
  }

  asm volatile("# find_n_prime end");
  return (u32)(((1ULL << R_POWER) - y));
}

// RSA encryption using montgomery multiplication
u32 rsa_montgomery_encrypt(u32 data, u32 PQ, u32 E);

// RSA decryption using montgomery multiplication
u32 rsa_montgomery_decrypt(u32 data, u32 PQ, u32 D);

// Montgomery reduction function
u32 montgomery_reduce(u64 x, u32 n_prime, u32 n);


#endif
