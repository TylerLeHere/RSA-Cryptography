#include <stdint.h>
#include <stdio.h>

#define u32 __uint32_t
#define u64 __uint64_t
#define R_POWER 32

#define ENCRYPT rsa_modexp_encrypt
#define DECRYPT rsa_modexp_decrypt

// Compute modular exponentiation (base^exp % mod)
u32 mod_exp(u32 base, u32 exp, u32 mod) {
  if (exp == 0)
    return 1;

  u64 result = 1;
  u64 base_mod = base % mod;

  for (u32 i = 0; i < exp; ++i) {
    result = (result * base_mod) % mod;
  }

  return (u32)result;
}

// RSA encryption: C = data^E mod PQ
u32 rsa_modexp_encrypt(u32 data, u32 PQ, u32 E) { return mod_exp(data, E, PQ); }

// RSA decryption: M = data^D mod PQ
u32 rsa_modexp_decrypt(u32 data, u32 PQ, u32 D) { return mod_exp(data, D, PQ); }

//------------------------------------------------------------------------------------------------------------------------
// MONTGOMERY MUTIPLICATION SECTION

// Convert to montgomery domain
// Param x: The number to convert to montgomery space
// Param n: The modulus that we are converting to montgomery space for
inline u32 convert_to_montgomery(u32 x, u32 n) {
  u64 temp_result = (u64)x << R_POWER;
  return (u32)(temp_result % n);
}

// RSA encryption using montgomery multiplication
u32 rsa_montgomery_encrypt(u32 data, u32 PQ, u32 E) {
  // convert to montgomery space

  return 0;
}

// RSA decryption using montgomery multiplication
u32 rsa_montgomery_decrypt(u32 data, u32 PQ, u32 D) { return 0; }

// Integer power (no modulus)
u64 power(u32 base, u32 exp) {
  if (exp == 0)
    return 1;

  u64 result = 1;
  for (u32 i = 0; i < exp; ++i) {
    result *= base;
  }

  return result;
}

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
  u32 e = 3; // Start at 3 (common practice)

  while (e < PQ_mult) {
    if (gcd(e, PQ_mult) == 1) {
      return e;
    }
    e += 2; // skip even numbers
  }

  return 1; // fallback (shouldn't happen)
}

// Compute private exponent D such that (D * E) % ((P-1)*(Q-1)) == 1
u32 find_d(u32 P, u32 Q, u32 E) {
  u64 totient = (u64)(P - 1) * (Q - 1);

  for (u64 i = 1;; ++i) {
    if ((i * totient + 1) % E == 0) {
      return (u32)((i * totient + 1) / E);
    }
  }
}

int main() {
  u32 P = 7919;
  u32 Q = 6287;
  u32 PQ = P * Q;

  u32 E = get_public_exponent(P, Q);
  u32 D = find_d(P, Q, E);

  printf("E = %u, D = %u, PQ = %u\n", E, D, PQ);

  u32 inputText = 788;
  printf("INPUT TEXT is %u\n", inputText);

  u32 encrypted_text = ENCRYPT(inputText, PQ, E);
  printf("Encrypted text is %u\n", encrypted_text);

  u32 output = DECRYPT(encrypted_text, PQ, D);
  printf("FINAL TEXT IS %u\n", output);

  return 0;
}
