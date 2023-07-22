int f (int a) {
	return a + 1;
}

int g(int argc) {
	if (argc > 2) {
		return f(argc);
	} else {
		return 0;
	}
}

int main(int argc, char** argv) {
	return g(argc);
}
