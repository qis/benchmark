#include <error_code.hpp>
#include <native.hpp>
#include <benchmark/benchmark.h>
#include <string_view>

inline std::string_view error_code_string(std::error_code& ec) noexcept
{
  ec.clear();
  const char* data = nullptr;
  size_t size = 0;
  if (const auto e = static_cast<error>(native_string(&data, &size)); e != error::success) {
    ec = make_error_code(e);
    return {};
  }
  return { data, size };
}

inline std::string_view error_code_pass(std::error_code& ec) noexcept
{
  const auto value = error_code_string(ec);
  if (ec) {
    return {};
  }
  return value;
}

inline std::error_code error_code_check() noexcept
{
  std::error_code ec;
  const auto value = error_code_pass(ec);
  if (!ec) {
    const auto value_size = value.size();
    benchmark::DoNotOptimize(value_size);
  }
  return ec;
}

static void error_code(benchmark::State& state, int fail) noexcept
{
  native_fail(fail);
  state.SetLabel(TOOLCHAIN_NAME);
  for (auto _ : state) {
    const auto error = error_code_check();
    benchmark::DoNotOptimize(error);
  }
}
BENCHMARK_CAPTURE(error_code, success, 0);
BENCHMARK_CAPTURE(error_code, failure, 1);
