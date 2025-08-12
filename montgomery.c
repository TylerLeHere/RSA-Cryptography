#include "montgomery.h"
#include <stdio.h>

void fill_LUT(u32 *LUT, u32 data, u32 PQ) {

  u32 base_mont = montgomery_transform(data, PQ);
  u32 n_prime = find_n_prime(PQ);

  for (int i = 0; i < R_POWER; ++i) {
    LUT[i] = base_mont;
    base_mont = montgomery_reduce((u64)base_mont * base_mont, n_prime, PQ);
  }
}

// Corrected Montgomery reduction
u32 montgomery_reduce(u64 T, u32 n_prime, u32 n) {
  asm volatile("# reduce start");
  u32 q = (u32)(T * n_prime); // q = (T * n') mod R , the mod R is done by
                              // reducing to u32 with intentional unsigned
                              // integer overflow

  u64 mN = (u64)q * n;         // m = q * n
  u32 t = (T + mN) >> R_POWER; // t = Tx + mN) / R

  return (u32)t;
  asm volatile("# reduce end");
}

// Binary exponentiation in Montgomery domain
u32 montgomery_exp(register u32 base_mont, register u32 exp, u32 n_prime,
                   register u32 n) {
  // Will implement using multiply and square algorithm while in montgomery
  // domain.
  // go right to left through exp accumulating the current squared_result
  // if current bit is 1 then multiply it with final result & store
  // get 1 in montgomery domain
  u32 result = montgomery_transform(1, n);

  while (exp) {
    // if rightmost bit is 1
    if (exp & 1) {
      result = montgomery_reduce((u64)base_mont * result, n_prime, n);
    }

    // accumulate squared result
    base_mont = montgomery_reduce((u64)base_mont * base_mont, n_prime, n);

    exp >>= 1;
  }

  return result;
}

u32 montgomery_exp_lut_optimized(register u32 base_mont, register u32 exp,
                                 u32 n_prime, u32 n, u32 *LUT) {
  register u32 count = 0;
  // get 1 in montgomery domain
  u32 result = montgomery_transform(1, n);

  while (exp) {
    // if rightmost bit is 1
    if (exp & 1) {
      result = montgomery_reduce((u64)LUT[count] * result, n_prime, n);
    }
    ++count;
    exp >>= 1;
  }
  return result;
}

// RSA encryption using Montgomery multiplication
u32 rsa_montgomery_encrypt(u32 data, u32 PQ, u32 E) {
  DEBUG("Montgomery Encrypt: data=%u, PQ=%u, E=%u\n", data, PQ, E);

  // Convert to Montgomery space
  u32 data_mont = montgomery_transform(data, PQ);
  DEBUG("  data in Montgomery form: %u\n", data_mont);

  // Find n'
  u32 n_prime = find_n_prime(PQ);
  DEBUG("  n_prime: %u\n", n_prime);

// Perform exponentiation in Montgomery domain
// Perform exponentiation in Montgomery domain
#ifndef LUT_ENABLED
  u32 result_mont = montgomery_exp(data_mont, E, n_prime, PQ);
#else
  u32 LUT[32];
  fill_LUT(LUT, data, PQ);
  u32 result_mont =
      montgomery_exp_lut_optimized(data_mont, E, n_prime, PQ, LUT);
#endif

  DEBUG("  result in Montgomery form: %u\n", result_mont);

  // Convert back from Montgomery space
  u32 final_result = montgomery_reduce(result_mont, n_prime, PQ);
  DEBUG("  final result: %u\n", final_result);
  asm volatile("# reduce end");

  return final_result;
}

// RSA decryption using Montgomery multiplication
u32 rsa_montgomery_decrypt(u32 data, u32 PQ, u32 D) {
  DEBUG("Montgomery Decrypt: data=%u, PQ=%u, D=%u\n", data, PQ, D);

  // Convert to Montgomery space
  u32 data_mont = montgomery_transform(data, PQ);
  DEBUG("  data in Montgomery form: %u\n", data_mont);

  u32 n_prime = find_n_prime(PQ);
  DEBUG("  n_prime: %u\n", n_prime);

// Perform exponentiation in Montgomery domain
#ifndef LUT_ENABLED
  u32 result_mont = montgomery_exp(data_mont, D, n_prime, PQ);
#else
  u32 LUT[32];
  fill_LUT(LUT, data, PQ);
  u32 result_mont =
      montgomery_exp_lut_optimized(data_mont, D, n_prime, PQ, LUT);
#endif

  DEBUG("  result in Montgomery form: %u\n", result_mont);

  // Convert back from Montgomery space
  u32 final_result = montgomery_reduce(result_mont, n_prime, PQ);
  DEBUG("  final result: %u\n", final_result);

  return final_result;
}
