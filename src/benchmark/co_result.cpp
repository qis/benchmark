#include <error.hpp>
#include <native.hpp>
#include <result.hpp>
#include <benchmark/benchmark.h>
#include <string_view>

inline result<std::string_view> co_result_string() noexcept
{
  const char* data = nullptr;
  size_t size = 0;
  if (const auto e = static_cast<error>(native_string(&data, &size)); e != error::success) {
    return e;
  }
  return { data, size };
}

inline result<std::string_view> co_result_pass() noexcept
{
  const auto value = co_await co_result_string();
  co_return value;
}

inline error co_result_check() noexcept
{
  if (const auto value = co_result_pass()) {
    const auto value_size = value.value().size();
    benchmark::DoNotOptimize(value_size);
    return error::success;
  } else {
    return value.error();
  }
}

static void co_result(benchmark::State& state, int fail) noexcept
{
  native_fail(fail);
  state.SetLabel(TOOLCHAIN_NAME);
  for (auto _ : state) {
    const auto error = co_result_check();
    benchmark::DoNotOptimize(error);
  }
}
BENCHMARK_CAPTURE(co_result, success, 0);
BENCHMARK_CAPTURE(co_result, failure, 1);
