/* Scenario that justifies elementwise persistence counting.
 * With associativity 2, elementwise counting will find out that persis is
 * persistent while setwise counting won't */

#include "../address_magic.h"

/* local variables are in high cachesets */
volatile int *complex_expression = ADDRESS(0,1,0);
volatile int *persis = ADDRESS(1,2,0);
volatile int *conflict1 = ADDRESS(2,2,0);
volatile int *conflict2 = ADDRESS(3,2,0);

int main() {
	for (int i=0; i<100; i++) {
		if(*complex_expression) {
			*conflict1;
		} else {
			*persis;
			*conflict2;
			*persis;
		}
		if(*complex_expression) {
			*persis;
		}
	}
	return 0;
}
