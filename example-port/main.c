/*
 * hello-tiramisu - Example program for Tiramisu OS
 */
#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    printf("Hello from Tiramisu OS third-party port!\n");
    printf("Running on PID %d (UID %d)\n", getpid(), getuid());
    if (argc > 1) {
        printf("Arguments received:\n");
        for (int i = 1; i < argc; i++) {
            printf("  [%d] %s\n", i, argv[i]);
        }
    }
    return 0;
}
