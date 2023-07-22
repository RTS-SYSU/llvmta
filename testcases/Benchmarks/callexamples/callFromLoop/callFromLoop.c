void a() {
}

void b() {
	for (int i = 0; i < 10; ++i) {
		a();
	}
}

int main() {
	int a = 0;
	int c = 0;
	if (a == 0) {
		c = 1;
	} else {
		c = 2;
	}
	b();
	return 0;
}
