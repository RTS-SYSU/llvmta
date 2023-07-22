/* This testcase generates a state graph where both branches of an if are part
 * of the WCET path (because one might be inclined to think it's not possible). 
 * One path contains a store, which allows a writeback on the
 * other path. The worst-case is thus executing each branch 256 times */

/* assumes associativity 2, ptr, sum and complex_expression should be in the same cache set. */
volatile int* ptr = (int*) 0x10;
volatile int* sum = (int*) 0x14;
volatile int* complex_expression = (int*) 0x18;
int main()
{
	for(int i=0; i<512; i++) {
		if(*complex_expression) {
			/* store */
			*ptr = 5;
		} else {
			/* cause writeback by evicting ptr */
			*sum += *ptr;
		}
	}
}
