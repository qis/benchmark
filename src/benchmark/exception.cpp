#include <error.hpp>
#include <native.hpp>
#include <benchmark/benchmark.h>
#include <string_view>

inline std::string_view exception_string()
{
  const char* data = nullptr;
  size_t size = 0;
  if (const auto e = static_cast<error>(native_string(&data, &size)); e != error::success) {
    throw e;
  }
  return { data, size };
}

inline std::string_view exception_pass()
{
  const auto value = exception_string();
  return value;
}

inline error exception_check() noexcept
{
  try {
    const auto value = exception_pass();
    const auto value_size = value.size();
    benchmark::DoNotOptimize(value_size);
  }
  catch (error error) {
    return error;
  }
  catch (...) {
    return error::failure;
  }
  return error::success;
}

static void exception(benchmark::State& state, int fail) noexcept
{
  native_fail(fail);
  state.SetLabel(TOOLCHAIN_NAME);
  for (auto _ : state) {
    const auto error = exception_check();
    benchmark::DoNotOptimize(error);
  }
}
BENCHMARK_CAPTURE(exception, success, 0)->Unit(benchmark::kNanosecond);
BENCHMARK_CAPTURE(exception, failure, 1)->Unit(benchmark::kNanosecond);
