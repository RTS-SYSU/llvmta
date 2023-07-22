#define INDEX_SHIFT 4 /* 16 bytes linesize */
#define TAG_SHIFT (INDEX_SHIFT)+5 /* 32 cache sets */

#define ADDRESS(tag,index,offset) ((tag << TAG_SHIFT) | (index << INDEX_SHIFT) | offset)

#define ADDRESS_ADD_TO_TAG(pointer, value) ((unsigned)(pointer) + (value << TAG_SHIFT))
