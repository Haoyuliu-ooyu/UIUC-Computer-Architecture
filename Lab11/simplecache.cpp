#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  std::vector< SimpleCacheBlock > &b = _cache[index];
  for (int i = 0; i < _associativity; i++) {
    if (b[i].tag() == tag && b[i].valid()) {
      return b[i].get_byte(block_offset);
    }
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign (see "C++ Rule of Three")
  std::vector<SimpleCacheBlock> &b = _cache[index];
  for (int i = 0; i < _associativity; i++) {
    if (!b[i].valid()) {
      b[i].replace(tag, data);
      return;
    }
  }
  b[0].replace(tag, data);
}
