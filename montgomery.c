#include "montgomery.h"

// MONTGOMERY MUTIPLICATION SECTION

// RSA encryption using montgomery multiplication
// C = data^E mod PQ
u32 rsa_montgomery_encrypt(u32 data, u32 PQ, u32 E) {
  // convert to montgomery space
  u32 data_mont = montgomery_transform(data, PQ);

  // find N' = - N^-1 % R ie. find x s.t N * x % R = 1
  u32 n_prime = find_n_prime(PQ);

  u32 result = data_mont;
  for (u32 i = 0; i < E; ++i) {
    result = montgomery_reduce((u64)result * data_mont, n_prime, PQ);
  }

  return montgomery_transform(result, PQ);
}

// RSA decryption using montgomery multiplication
u32 rsa_montgomery_decrypt(u32 data, u32 PQ, u32 D) {
  // convert to montgomery space
  u32 data_mont = montgomery_transform(data, PQ);

  // find N' = - N^-1 % R ie. find x s.t N * x % R = 1
  u32 n_prime = find_n_prime(PQ);

  u32 result = data_mont;
  for (u32 i = 0; i < D; ++i) {
    result = montgomery_reduce((u64)result * data_mont, n_prime, PQ);
  }

  return montgomery_transform(result, PQ);
}

u32 montgomery_reduce(u64 x, u32 n_prime, u32 n) {
  u32 q = (u32)x * n_prime; // q = x * n' mod r
  u64 m = (u64)q * n;       // m = q * n
  u32 y = (x - m) >> 32;    // y = (x - m) / r
  return x < m ? y + n : y; // if y < 0, add n to make it be in the [0, n) range
}
