/* testcase designed to give different results depending on the type of WB-bound chosen */
volatile int x;
volatile extern int* getUnknownValue;

int main()
{
	volatile int* unknown = getUnknownValue;
	/* three stores, but only one dirtifying store */
	x = 5;
	x = 4;
	x = 3;

	while (*unknown)
		;
}
