#include "address_magic.h"

volatile unsigned char a[32*16]; /* 32 sets, 16 bytes per line */
volatile int *x = ADDRESS(1,3,0);

int main(void)
{
	/* the analysis should be able to prove that x cannot be aged more than
	 * once, i.e. that x cannot be evicted*/
	*x;

	for (int i=0; i<512; i++) {
		a[i];
	}
	return *x; /* this should be a cache hit */
}
