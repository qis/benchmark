#include "native.hpp"
#include <error.hpp>

namespace {

int g_should_fail = 0;

}  // namespace

NATIVE_API int native_fail(int fail)
{
  g_should_fail = fail;
  return static_cast<int>(error::success);
}

NATIVE_API int native_string(const char** data, size_t* size)
{
  if (g_should_fail) {
    return static_cast<int>(error::failure);
  }
  *data = "success";
  *size = 7;
  return static_cast<int>(error::success);
}
