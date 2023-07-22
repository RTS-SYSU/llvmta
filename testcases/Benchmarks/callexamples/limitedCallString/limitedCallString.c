// If call string only length 1, then we have to merge call sequences

void a() {

}

void b() {
	a();
}

void c() {
	a();
}

void d() {
	int x = 6;
	b();
}

void e() {
	b();
}

int main() {
	c();
	d();
	e();
	return 0;
}
