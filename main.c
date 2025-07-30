#include <stdint.h>
#include <stdio.h>

#define IntType uint64_t

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
  return (i * num + 1) / E;
}

IntType gcd(IntType a, IntType b) {
  while (b != 0) {
    IntType temp = b;
    b = a % b;
    a = temp;
  }
  return a;
}

// Get public exponent E which is some int that
// is Less than PQ and has no common factors
//  with (P-1)*(Q-1)
IntType get_public_exponent(IntType P, IntType Q) {
  IntType PQ = (P - 1) * (Q - 1);
  IntType e =
      3; // Common starting point, since 2 is often not coprime for small primes

  while (e < PQ) {
    if (gcd(e, PQ) == 1) {
      return e;
    }
    e += 2; // Use odd values only to skip even numbers
  }

  // I really hope this never happens
  return 1;
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

  IntType P = 4133;
  IntType Q = 4507;
  IntType PQ = P * Q; // modulus

  IntType E =
      get_public_exponent(P, Q); // Public exponent: Less than PQ and has no
                                 // common factors with (P-1)*(Q-1)

  IntType D = find_d(P, Q, E); // private exponent

  printf("E = %u ,D = %u, PQ = %u \n", E, D, PQ);

  // Define and print inputText (for report)
  IntType inputText = 7;
  printf("INPUT TEXT is %u \n", inputText);

  // Compute and print encrypted_text (for report)
  IntType encrypted_text = ENCRYPT(inputText, PQ, E);
  printf("Encrypted text is %u \n", encrypted_text);

  // Compute and print final recovered text, this should be the same as
  // inputText
  IntType output = DECRYPT(encrypted_text, PQ, D);
  printf("FINAL TEXT IS %u \n", output);
}
