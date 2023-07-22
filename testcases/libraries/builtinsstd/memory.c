#include <stddef.h>

void* memcpy(void* destination, const void* source, size_t num)
{
	char* destination8 = (char*) destination;
	char* source8 = (char*) source;
	// Cannot provide any loop bound here
	for(int i = 0; i < num; ++i) {
		destination8[i] = source8[i];
	}
}

void* memset(void* ptr, int value, size_t num)
{
	unsigned char* ptr8 = (unsigned char*) ptr;
	// Cannot provide any loop bound here
	for(int i = 0; i < num; ++i) {
		ptr8[i] = (unsigned char) value;
	}
	return ptr;
}
