project(rsa LANGUAGES C)

add_executable(rsa main.c montgomery.c modular_exponentiation.c)
