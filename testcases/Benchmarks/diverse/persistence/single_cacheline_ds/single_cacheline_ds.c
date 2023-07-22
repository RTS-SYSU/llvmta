/* This test checks whether small arrays that fit into a cacheline are
 * treated as "normal" variables. globalvector should be persistent */

#include "../address_magic.h"

volatile int globalvector[4]; /* this is in cacheset 0 */
int main() {
	volatile int *conflict1 = ADDRESS(1,0,0);
	volatile int *conflict2 = ADDRESS(2,0,0);
	volatile int *complex_expression = ADDRESS(0,0xa,0); /* cacheset a should be out of the way */

	for (int i=0; i<sizeof(globalvector)/sizeof(globalvector[0]); i++) {
		globalvector[i];
		if (*complex_expression) {
			*conflict1; /* confuse MUST analysis */
		}
		*conflict1;
		globalvector[i];
		*conflict2;
	}

	/* check if the same thing also works for local arrays. Note: it doesn't
	 * in LLVMTA, but I leave this test in here for future reference */

	/* compute addresses for the conflicts: same lower part, different tag */
	volatile int localvector[3];
	volatile int *localconflict1 = (int*) (((unsigned)&localvector) + (1 << 9));
	volatile int *localconflict2 = (int*) (((unsigned)&localvector) + (2 << 9));
	for (int i=0; i<sizeof(localvector)/sizeof(localvector[0]); i++) {
		localvector[i];
		if (*complex_expression) {
			*localconflict1; /* confuse MUST analysis */
		}
		*localconflict1;
		localvector[i];
		*localconflict2;
	}
}
