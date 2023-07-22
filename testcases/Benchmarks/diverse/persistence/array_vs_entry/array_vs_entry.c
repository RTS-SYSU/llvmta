/* Checks whether datastructure persistence and normal persistence work together
 * properly. ARRAY is persistent for associativity 2, but a stupid persistence
 * analysis might put array[0] into the conflict set of array and declare array
 * nonpersistent */
volatile unsigned char array[32*16*2];
int main() {
	for (int i=0; i<sizeof(array)/sizeof(array[0]); i++) {
		array[i];
		array[0];
	}
}
