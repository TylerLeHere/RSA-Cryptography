#include "modular_exponentiation.h"

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
