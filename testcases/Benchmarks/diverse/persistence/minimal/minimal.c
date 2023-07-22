#include "../address_magic.h"

/* local variables will be placed on the stack, i.e. high cachesets. accessA and
 * accessB themselves are in cacheset 0 */
volatile int* accessA = ADDRESS(1,2,0);
volatile int* accessB = ADDRESS(2,2,0);
volatile int* ce = ADDRESS(1,1,0);

int main() {
	for (int i=0; i<100; i++) {
		if (*ce) {
			*accessA;
		} else {
			*accessB;
		}
	}
}
