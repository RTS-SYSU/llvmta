int main() {
  // 	int i = 0;
  // label1:
  // 	_Pragma("loopbound min 0 max 100")
  // 	i++;
  // label2:
  // 	_Pragma("loopbound min 0 max 100")
  // 	i *= 2;
  //   goto label3;
  // label3:
  // 	if (i > 50)
  // 		goto label1;
  // 	i -= 3;
  // 	if (i >= 20)
  // 		goto label2;
  // 	return 0;
  int sum = 0;
  int i = 0;
  int j = 0;
  for (; i < 10; i++) {
    for (; j < 12; j++)
      sum += (i + j);
  }
  return sum;
}
