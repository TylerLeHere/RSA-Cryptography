#include "montgomery.h"
#include <stdio.h>

// Corrected Montgomery reduction
u32 montgomery_reduce(u64 x, u32 n_prime, u32 n) {
    u32 q = (u32)(x * n_prime);  // q = (x * n') mod R (lower 32 bits)
    u64 m = (u64)q * n;          // m = q * n
    u64 t = (x + m) >> R_POWER;  // t = (x + m) / R

    // If t >= n, subtract n to ensure result is in [0, n)
    return (u32)(t >= n ? t - n : t);
}

// Binary exponentiation in Montgomery domain
u32 montgomery_exp(u32 base_mont, u32 exp, u32 n_prime, u32 n) {
    if (exp == 0) {
        // Return 1 in Montgomery form
        return montgomery_transform(1, n);
    }

    u32 result = montgomery_transform(1, n); // 1 in Montgomery form
    u32 base = base_mont;

    while (exp > 0) {
        if (exp & 1) {
            // result = result * base (in Montgomery domain)
            result = montgomery_reduce((u64)result * base, n_prime, n);
        }
        // base = base^2 (in Montgomery domain)
        base = montgomery_reduce((u64)base * base, n_prime, n);
        exp >>= 1;
    }

    return result;
}

// RSA encryption using Montgomery multiplication
u32 rsa_montgomery_encrypt(u32 data, u32 PQ, u32 E) {
    printf("Montgomery Encrypt: data=%u, PQ=%u, E=%u\n", data, PQ, E);

    // Convert to Montgomery space
    u32 data_mont = montgomery_transform(data, PQ);
    printf("  data in Montgomery form: %u\n", data_mont);

    // Find n'
    u32 n_prime = find_n_prime(PQ);
    printf("  n_prime: %u\n", n_prime);

    // Perform exponentiation in Montgomery domain
    u32 result_mont = montgomery_exp(data_mont, E, n_prime, PQ);
    printf("  result in Montgomery form: %u\n", result_mont);

    // Convert back from Montgomery space
    u32 final_result = montgomery_reduce(result_mont, n_prime, PQ);
    printf("  final result: %u\n", final_result);

    return final_result;
}

// RSA decryption using Montgomery multiplication
u32 rsa_montgomery_decrypt(u32 data, u32 PQ, u32 D) {
    printf("Montgomery Decrypt: data=%u, PQ=%u, D=%u\n", data, PQ, D);

    // Convert to Montgomery space
    u32 data_mont = montgomery_transform(data, PQ);
    printf("  data in Montgomery form: %u\n", data_mont);

    u32 n_prime = find_n_prime(PQ);
    printf("  n_prime: %u\n", n_prime);

    // Perform exponentiation in Montgomery domain
    u32 result_mont = montgomery_exp(data_mont, D, n_prime, PQ);
    printf("  result in Montgomery form: %u\n", result_mont);

    // Convert back from Montgomery space
    u32 final_result = montgomery_reduce(result_mont, n_prime, PQ);
    printf("  final result: %u\n", final_result);

    return final_result;
}