int main() {
	int i = 0;
label1:
	_Pragma("loopbound min 0 max 100")
	i++;
label2:
	_Pragma("loopbound min 0 max 100")
	i *= 2;
  goto label3;
label3:
	if (i > 50)
		goto label1;
	i -= 3;
	if (i >= 20)
		goto label2;
	return 0;
}
