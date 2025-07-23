#include <stdint.h>
#include <stdio.h>

#define IntType uint32_t

#define ENCRYPT rsa_modexp_encrypt
#define DECRYPT rsa_modexp_decrypt

// Take the get the modular exponentiation of two unsigned integers
IntType mod_exp(IntType base, IntType pow, IntType mod) {
  if (pow == 0) {
    return base % mod;
  }

  IntType result = 1;
  for (int i = 0; i < pow; ++i) {
    result = (result * base) % mod;
  }

  return result;
}

// Take a power of two unsigned integers
IntType power(IntType base, IntType pow) {
  if (pow == 0) {
    return 1;
  }
  IntType result = 1;
  for (int i = 0; i < pow; ++i) {
    result *= base;
  }

  return result;
}

// Find the appropriate D value for the given parameters
IntType find_d(IntType P, IntType Q, IntType E) {
  IntType num = (P - 1) * (Q - 1);
  int i;
  for (i = 0;; ++i) {
    if ((i * num + 1) % E == 0) {
      break;
    }
  }
  // printf("i is %u \n ", i);

  return (i * num + 1) / E;
}

IntType rsa_encrypt(IntType data, IntType PQ, IntType E) {
  // C = data^E mod PQ
  return power(data, E) % (PQ);
}

IntType rsa_decrypt(IntType data, IntType PQ, IntType D) {
  // result = data^D mod PQ
  return power(data, D) % (PQ);
}

IntType rsa_modexp_encrypt(IntType data, IntType PQ, IntType E) {
  return mod_exp(data, E, PQ);
}

IntType rsa_modexp_decrypt(IntType data, IntType PQ, IntType D) {
  return mod_exp(data, D, PQ);
}

int main() {

  IntType P = 251;
  IntType Q = 7;
  IntType PQ = P * Q; // modulus

  IntType E = 7; // Public exponent: Less than PQ and has no common factors
                 // with (P-1)*(Q-1)
  IntType D = find_d(P, Q, E); // private exponent

  printf("E = %u ,D = %u, PQ = %u \n", E, D, PQ);

  // Define and print inputText (for report)
  IntType inputText = 7;
  printf("Input text is %u \n", inputText);

  // Compute and print encrypted_text (for report)
  IntType encrypted_text = ENCRYPT(inputText, PQ, E);
  printf("Encrypted text is %u \n", encrypted_text);

  // Compute and print final recovered text, this should be the same as
  // inputText
  IntType output = DECRYPT(encrypted_text, PQ, D);
  printf("Final recovered text is %u \n", output);
}
