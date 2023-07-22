class A
{
	public:
	virtual int f() { return 5; }
};

class B : public A
{
	public:
	virtual int f() {return 3; }
};

int main(int argc, char** argv)
{
	A* a = new A();
	if (argc > 2) {
		a = new B();
	}
	return a->f();
}
