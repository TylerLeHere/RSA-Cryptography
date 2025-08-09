#include "montgomery.h"

// MONTGOMERY MUTIPLICATION SECTION



// RSA encryption using montgomery multiplication
// C = data^E mod PQ
u32 rsa_montgomery_encrypt(u32 data, u32 PQ, u32 E) {
  // convert to montgomery space
  u32 data_mont = convert_to_montgomery(data, PQ);

  // find N' = - N^-1 % R ie. find x s.t N * x % R = 1

  return 0;
}

// RSA decryption using montgomery multiplication
u32 rsa_montgomery_decrypt(u32 data, u32 PQ, u32 D) {
  // convert to montgomery space
  u32 data_mont = convert_to_montgomery(data, PQ);
  // find N' = - N^-1 % R ie. find x s.t N * x % R = 1
  u32 n_prime = find_n_prime(PQ);

  u32 result = data_mont;
  for (u32 i = 0; i < D; ++i) {
    result = montgomery_reduce((u64)result * data_mont, n_prime, PQ);
  }

  return montgomery_transform(result, PQ);
}

// Corrected Montgomery reduction
u32 montgomery_reduce(u64 x, u32 n_prime, u32 n) {
  u32 q = (u32)(x * n_prime);
  u64 m = (u64)q * n;
  u64 t = (x + m) >> R_POWER;

  return (u32)(t >= n ? t - n : t);
}

