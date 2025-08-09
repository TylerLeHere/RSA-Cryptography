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

// Extended Euclidean Algorithm to find n'
// We need n' such that n * n' ≡ -1 (mod R) where R = 2^32
static inline u32 find_n_prime(u32 n) {
  u64 R = 1ULL << R_POWER;  // R = 2^32

  int64_t r_old = R;
  int64_t r = n;

  int64_t s_old = 1;
  int64_t s = 0;

  int64_t t_old = 0;
  int64_t t = 1;

  while (r != 0) {
    int64_t quotient = r_old / r;

    int64_t temp = r;
    r = r_old - quotient * r;
    r_old = temp;

    temp = s;
    s = s_old - quotient * s;
    s_old = temp;

    temp = t;
    t = t_old - quotient * t;
    t_old = temp;
  }

  u32 n_inverse = (u32)((t_old % (int64_t)R + (int64_t)R) % (int64_t)R);
  return (u32)((R - n_inverse) & 0xFFFFFFFFU);
}

// RSA encryption using montgomery multiplication
u32 rsa_montgomery_encrypt(u32 data, u32 PQ, u32 E);

// RSA decryption using montgomery multiplication
u32 rsa_montgomery_decrypt(u32 data, u32 PQ, u32 D);

// Montgomery reduction function
u32 montgomery_reduce(u64 x, u32 n_prime, u32 n);

#endif