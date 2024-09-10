#include <stdio.h>

int __wrap_main(void);

int main() {
  printf("Before wrap main\n");
  __wrap_main();
  printf("After wrap main\n");
  return 0;
}
