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

  return 0;
}
