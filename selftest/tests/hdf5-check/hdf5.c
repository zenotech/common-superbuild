#include <hdf5.h>

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    int ret = EXIT_SUCCESS;

    htri_t deflate_avail = H5Zfilter_avail(H5Z_FILTER_DEFLATE);
    if (deflate_avail < 0) {
        fprintf(stderr, "Failed to determine deflate support\n");
        ret = EXIT_FAILURE;
    } else if (!deflate_avail) {
        fprintf(stderr, "Missing deflate support\n");
        ret = EXIT_FAILURE;
    }

    htri_t szip_avail = H5Zfilter_avail(H5Z_FILTER_SZIP);
    if (szip_avail < 0) {
        fprintf(stderr, "Failed to determine szip support\n");
        ret = EXIT_FAILURE;
    } else if (!szip_avail) {
        fprintf(stderr, "Missing szip support\n");
        ret = EXIT_FAILURE;
    }

    return ret;
}
