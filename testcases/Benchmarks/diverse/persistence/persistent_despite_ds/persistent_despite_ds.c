/* tests if persistence adds datastructures to the conflict set beyond their
 * cache depth. Variable names indicate expected persistence*/
#include "../address_magic.h"

volatile unsigned char ds_depth1[16*32];
volatile unsigned char ds_depth2[16*32*2];
int main() {
	volatile int *complex_expression = ADDRESS(0,0xa,0);
	volatile int *persistent_at_assoc_2 = ADDRESS(0,1,0);
	volatile int *persistent_at_assoc_3 = ADDRESS(1,1,0);
	for (int i=0; i<sizeof(ds_depth1)/sizeof(ds_depth1[0]); i++) {
		if (*complex_expression) {
			*persistent_at_assoc_2;
		}
		ds_depth1[i];
	}
	
	for (int i=0; i<sizeof(ds_depth2)/sizeof(ds_depth2[0]); i++) {
		if (*complex_expression) {
			*persistent_at_assoc_3;
		}
		ds_depth2[i];
	}
}
