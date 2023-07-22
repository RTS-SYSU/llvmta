int main(int argc, char** argv)
{
	double sum = 1.0;
	if (argc > 2) {
		sum += 3.0;
	} else {
		sum += 5.0;
	}
	sum = sum + argc * 6.0;
	return (int) sum;
}
