#include <stdint.h>
#include <stdio.h>



#define IntType u_int32_t

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

IntType find_d(IntType P, IntType Q, IntType E) {
    IntType num = (P-1) * (Q-1);
    int i;
    for (i = 0; ;++i) {
        if ((i*num + 1) % E == 0) {
            break;
        }
    }
    printf("i is %u \n ", i);

    return (i*num + 1) / E;
}

IntType rsa_encrypt(IntType data, IntType PQ, IntType E) { 
    // C = data^E mod PQ
    return power(data, E) % (PQ); 
}

IntType rsa_decrypt(IntType data, IntType PQ, IntType D) { 
    // result = data^D mod PQ
    return power(data, D) % (PQ);
 }

int main() {
    IntType P = 7;
    IntType Q = 5;
    IntType PQ = P*Q; // modulus

    IntType E = 5; //Public exponent: Less than PQ and has no common factors with PQ
    IntType D = find_d(P, Q, E); //private exponent

    
    printf("D is %u \n", D);

    IntType inputText = 7;
    printf("Input text is %u \n", inputText);

    IntType encrypted_text = rsa_encrypt(inputText, PQ, E);
    printf("Encrypted text is %u \n", encrypted_text);

    IntType output = rsa_decrypt(encrypted_text, PQ, D);
    printf("Final recovered text is %u \n", output);
}



