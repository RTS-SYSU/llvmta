int a() {
	return 5;
}

int main(int argc, char** argv) {
	int i = 0;
	if (argc >= 2) {
		i += a();
		i += a();
	} else {
		i += a();
	}
	return i;
}

