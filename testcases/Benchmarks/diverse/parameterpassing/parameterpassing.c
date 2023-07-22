int f(int x) {
	return x;
}

double g (double d) { return d;}

double h (int y, double e) {return y+e;}

double k (int x, int h, double q, int j, int l) {return q+j+l;}

int main() {
	f(5);
	g(7.0);
	h(4,8.0);
	k(9,2,0.4,1,3);
	return 0;
}
