volatile int g;

void f() {
	g = g+1;
}

int main(int argc, char** argv) {
	if (argc > 3) {
		f();
	}
	return 1;
}
