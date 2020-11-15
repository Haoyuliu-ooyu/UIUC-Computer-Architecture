#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t index_ = _index << _cache_config.get_num_block_offset_bits();
  uint32_t tag_ = _tag << (_cache_config.get_num_index_bits() + _cache_config.get_num_block_offset_bits());
  return (tag_ | index_ | 0);
}