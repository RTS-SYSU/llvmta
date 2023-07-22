int a(int x) {
	if (x == 2) {	
		return 42;
	} else {
		return 23;
	}
}

int b(int x) {
	return a(x);
}

int main(int argc, char** argv) {
	if (argc > 2) {
		return b(2) + b(3);
	} else {
		return b(4);
	}
}
