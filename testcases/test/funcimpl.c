
int x = 100;
int my_loop(void *args) {
  int result = 0;
  for (int i = 0; i < 10; ++i) {
    result << 2;
  }
  return 0;
}

void my_loop2(void *args) {
  int result = 0;
  for (int i = 0; i < 10; ++i) {
    for (int j = 0; j < 12; ++j) {
      for (int k = 0; k < 10; ++k)
        result += (i + j + k);
    }
  }

  return;
}

void my_loop3(void *args) {
  int result = 0;
  for (int i = 0; i < 10; ++i) {
    for (int j = 0; j < 12; ++j) {
      for (int k = 0; k < 10; ++k)
        result += (i + j - k);
    }
  }

  return;
}

void my_loop4(void *args) {
  int result = 0;
  for (int i = 0; i < 100; ++i) {
    result += 11;
  }
  return;
}