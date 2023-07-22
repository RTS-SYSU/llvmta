int main() {
	int a = 0;
	int b = 1;
	if (a == b) {
		goto first;
	} else {
		goto second;
	}
first:
	if (a == 1) {
		goto end;
	}
	goto second;
second:
	a++;
	goto first;
end:
	return 0;
}
