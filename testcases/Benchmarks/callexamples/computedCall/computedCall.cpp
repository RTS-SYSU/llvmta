class A {
	public:
	virtual int f() { return 4;}
};

class B : public A {
	public:
	virtual int f() {return 5;}
};

int func(A* a) {
	return a->f();
}

int main() {
	return 0;
}
