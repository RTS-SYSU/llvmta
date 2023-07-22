int f(int* array, int n) {
	int sum = 0;
	for (unsigned idx = 0; idx < n; ++idx) {
		sum += array[idx];
	}
	return sum;
}

int main() {
	int array[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
	return f(&array[2], 8);
}
