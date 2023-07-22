int f(int i)
{
	return i+1;
}
int main(int argc, char** argv)
{
	int i = 0;
	for (i = 0; i < 10; ++i) {
	 	f(i);
	}
	return i;
}

