/* Test motivating the dfs-bound. This test ist all about causing the
 * dirtiness-analysis to predict a ludicrous amount of writebacks.
 * Assumed associativity is 2, linesize=16, nsets=32 */
#include "../address_magic.h"

volatile int* dirty = ADDRESS(1,2,0);
volatile unsigned char bigarr[32*16*4];

int main() {
	/* This part should predict 32*16*4 = 2048 writebacks, since each
	 * iteration of the loop might evict DIRTY or might not touch the set at
	 * all. */
	*dirty = 5;
	for (int i=0; i<sizeof(bigarr)/sizeof(bigarr[0]); i++) {
		bigarr[i];
	}
}
