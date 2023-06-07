#include <openssl/crypto.h>
#include <openssl/ssl.h>

#include <openssl/opensslv.h>

int main(int argc, char* argv[]) {
#if OPENSSL_VERSION_MAJOR == 3
    printf("crypto version: %d.%d.%d%s%s\n",
        OPENSSL_VERSION_MAJOR,
        OPENSSL_VERSION_MINOR,
        OPENSSL_VERSION_PATCH,
        OPENSSL_VERSION_PRE_RELEASE,
        OPENSSL_VERSION_BUILD_METADATA);
    printf("crypto libversion: %u.%u.%u%s%s\n",
        OPENSSL_version_major(),
        OPENSSL_version_minor(),
        OPENSSL_version_patch(),
        OPENSSL_version_pre_release(),
        OPENSSL_version_build_metadata());

    printf("ssl default cipher list: %s\n",
        OSSL_default_cipher_list());
    printf("ssl default cipher suites: %s\n",
        OSSL_default_ciphersuites());
#else
    printf("crypto version: " OPENSSL_VERSION_TEXT "\n");
    printf("crypto libversion: %s\n",
        OpenSSL_version(OPENSSL_VERSION));
#endif

    return EXIT_SUCCESS;
}
