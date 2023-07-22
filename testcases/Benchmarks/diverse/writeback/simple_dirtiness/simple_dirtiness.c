/* checks the functionality of the straightforward dirtiness analysis. Assumed
 * cache size is 2 */
#include "../address_magic.h"
volatile int* dirty = ADDRESS(1,1,0);
volatile int* clean1 = ADDRESS(2,1,0);
volatile int* clean2 = ADDRESS(3,1,0);
int main() {
	*dirty = 1;
	dirty[1] = 2; /* this store is free, since it goes to the same cacheline */
	*clean1;
	*clean2; /* should cause a writeback */
}
