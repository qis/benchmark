#pragma once
#include <cstdint>

enum class error : std::int64_t {
  success = 0,
  result_not_ready = 1,
  failure = 2,
};
