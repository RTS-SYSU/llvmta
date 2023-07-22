/* Checks whether persistence constraints are generated per cacheline or per
 * (true) address. The latter is suboptimal and should never be done.
 * If done correctly, there are at most 2 misses in this program since x and y
 * should share a persistence constraint.
 * Requirements: num_sets >= 2, linesize >= 2
 */

#include "../address_magic.h"

volatile unsigned char* x = ADDRESS(1,1,0);
volatile unsigned char* y = ADDRESS(1,1,1);
volatile unsigned char* conflict = ADDRESS(2,1,0);
volatile int* ce = ADDRESS(1,0,0);

int main() {
	for(int i=0; i<100; i++) {
		if (*ce) {
			*x;
		} else if (*ce) {
			*y;
		} else {
			/* confuse must-analysis */
		}
		*conflict;
	}
}
