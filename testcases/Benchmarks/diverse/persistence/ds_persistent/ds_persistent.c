/* tests if we are able to mark datastructures as persistent. Also tests what
 * happens if the datastructure is only persistent in some cachesets.
 * At the moment this is expected to fail (i.e. ds should be marked not
 * persistent), but in the future we might find some clever way to handle this */

#include "../address_magic.h"
volatile unsigned char ds_fully_persistent[16*16];
volatile unsigned char ds_partially_persistent[16*16];
int main() {
	volatile unsigned char *conflict0 = ADDRESS_ADD_TO_TAG(ds_fully_persistent,1);
	volatile unsigned char *conflict1 = ADDRESS_ADD_TO_TAG(ds_fully_persistent+(1<<INDEX_SHIFT),1);
	volatile int *ce = ADDRESS_ADD_TO_TAG(ds_partially_persistent,1); /* ce should be out of the way */

	for (int i=0; i<sizeof(ds_fully_persistent)/sizeof(*ds_fully_persistent); i++) {
		if (*ce) {
			ds_fully_persistent[i];
		}
		*conflict0;
		*conflict1;
	}


	ce = ADDRESS_ADD_TO_TAG(ds_fully_persistent,1); /* ce should be out of the way */
	volatile unsigned char *conflict16a = ADDRESS_ADD_TO_TAG(ds_partially_persistent,1);
	volatile unsigned char *conflict16b = ADDRESS_ADD_TO_TAG(ds_partially_persistent,2);
	volatile unsigned char *conflict17 = ADDRESS_ADD_TO_TAG(ds_partially_persistent+(1<<INDEX_SHIFT),1);

	for (int i=0; i<sizeof(ds_partially_persistent)/sizeof(*ds_partially_persistent); i++) {
		if (*ce) {
			ds_partially_persistent[i];
		}
		*conflict16a;
		*conflict17;
		*conflict16b; /* evicts ds from cacheset 16 */
	}
}
