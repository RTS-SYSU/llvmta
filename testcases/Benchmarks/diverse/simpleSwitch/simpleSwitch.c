enum color {
	red,
	green,
	blue,
	yellow
};

int f(enum color c) {
	int x = 0;
	switch (c) {
		case red:
			x = 1;
			break;
		case green:
			x = 2;
			break;
		case blue:
			x = 3;
			break;
		case yellow:
			x = 4;
			break;
		default:
			x = 0;
			break;
	}
	return x;
}

int main() {
	return f(red);
}
