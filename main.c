#include "config.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "modular_exponentiation.h"
#include "montgomery.h"

//------------------------------------------------------------------------------------------------------------------------

// Greatest common divisor (Euclidean algorithm)
u32 gcd(u32 a, u32 b) {
  while (b != 0) {
    u32 temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}

// Get public exponent E such that gcd(E, (P-1)(Q-1)) == 1
u32 get_public_exponent(u32 P, u32 Q) {
  u32 PQ_mult = (P - 1) * (Q - 1);
  u32 e = 3;

  while (e < PQ_mult) {
    if (gcd(e, PQ_mult) == 1) {
      return e;
    }
    e += 2; // skip even numbers
  }

  return 1; // fallback (shouldn't happen)
}

// Compute private exponent D such that (D * E) % ((P-1)*(Q-1)) == 1
// This can be precomputed it so it is fine if inneficient
u32 find_d(u32 P, u32 Q, u32 E) {
  u64 totient = (u64)(P - 1) * (Q - 1);

  for (u64 i = 1;; ++i) {
    if ((i * totient + 1) % E == 0) {
      return (u32)((i * totient + 1) / E);
    }
  }
}

void fill_LUT(u32 *LUT, u32 data, u32 PQ) {

  u32 base_mont = montgomery_transform(1, PQ);
  u32 n_prime = find_n_prime(PQ);

  for (int i = 0; i < R_POWER; ++i) {
    LUT[i] = base_mont;
    base_mont = montgomery_reduce((u64)base_mont * base_mont, n_prime, PQ);
  }
}

int main(int argc, char **argv) {
  int num_iters = (argc == 2) ? atoi(argv[1]) : 1000000;

  u32 P = 7919;
  u32 Q = 6287;
  u32 inputText = 788;

  u32 PQ = P * Q;

  u32 E = get_public_exponent(P, Q);
  u32 D = find_d(P, Q, E);

  u32 LUT[32];
  fill_LUT(LUT, inputText, PQ);

  for (int i = 0; i < num_iters; ++i) {

    DEBUG("E = %u, D = %u, PQ = %u\n", E, D, PQ);

    DEBUG("INPUT TEXT is %u\n", inputText);

    u32 encrypted_text = ENCRYPT(inputText, PQ, E, LUT);
    DEBUG("Encrypted text is %u\n", encrypted_text);

    u32 output = DECRYPT(encrypted_text, PQ, D, LUT);
    DEBUG("FINAL TEXT IS %u\n", output);
  }
  return 0;
}
