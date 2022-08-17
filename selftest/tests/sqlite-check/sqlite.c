#include <sqlite3.h>

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    printf("version: %s\n", sqlite3_version);
    printf("libversion: %s\n", sqlite3_libversion());
    printf("sourceid: %s\n", sqlite3_sourceid());
    printf("libversion_number: %d\n", sqlite3_libversion_number());
    return EXIT_SUCCESS;
}
