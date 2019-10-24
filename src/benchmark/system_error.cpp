#include <error_code.hpp>
#include <native.hpp>
#include <benchmark/benchmark.h>
#include <string_view>

inline std::string_view system_error_string()
{
  const char* data = nullptr;
  size_t size = 0;
  if (const auto e = static_cast<error>(native_string(&data, &size)); e != error::success) {
    throw std::system_error(make_error_code(e));
  }
  return { data, size };
}

inline std::string_view system_error_pass()
{
  const auto value = system_error_string();
  return value;
}

inline std::error_code system_error_check() noexcept
{
  try {
    const auto value = system_error_pass();
    const auto value_size = value.size();
    benchmark::DoNotOptimize(value_size);
  }
  catch (const std::system_error& e) {
    return e.code();
  }
  catch (...) {
    return make_error_code(error::failure);
  }
  return {};
}

static void system_error(benchmark::State& state, int fail) noexcept
{
  native_fail(fail);
  state.SetLabel(TOOLCHAIN_NAME);
  for (auto _ : state) {
    const auto error = system_error_check();
    benchmark::DoNotOptimize(error);
  }
}
BENCHMARK_CAPTURE(system_error, success, 0)->Unit(benchmark::kNanosecond);
BENCHMARK_CAPTURE(system_error, failure, 1)->Unit(benchmark::kNanosecond);
