int f(int x) {
	int sum = 0;
	for (int i = 0; i < x; ++i) {
		sum += i;
	}
	return sum;
}

int main() {
	return f(8);
}
