int f (int a) {
	int sum = 0;
	for (int i = 0; i < a; ++i) {
		sum += i;
	}
	return sum;
}

int g(int argc, char** argv) {
	if (argc < 2) {
		return 0;
	}

	return f(argc);
}

int main(int argc, char **argv) {
	return g(argc, argv);
}
