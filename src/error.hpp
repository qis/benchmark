#pragma once
#include <system_error>

enum class error {
  success = 0,
  failure = 1,
  result_not_ready = 2,
};

enum class condition {
  general_error = 1,
  result_error,
};

namespace std {

template <>
struct is_error_code_enum<::error> {
  static constexpr bool value = true;
};

template <>
struct is_error_condition_enum<::condition> {
  static constexpr bool value = true;
};

}  // namespace std
