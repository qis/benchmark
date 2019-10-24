#include <benchmark/benchmark.h>

constexpr auto g_warmup_count = 0;

int main(int argc, char* argv[])
{
  benchmark::Initialize(&argc, argv);
  if (benchmark::ReportUnrecognizedArguments(argc, argv)) {
    return 1;
  }

  if constexpr (g_warmup_count) {
    class Warmup : public benchmark::BenchmarkReporter {
    public:
      bool ReportContext(const Context& context) override
      {
        return true;
      }
      void ReportRuns(const std::vector<Run>& report) override
      {}
      void Finalize() override
      {}
    } warmup;

    for (auto i = 0; i < g_warmup_count; i++) {
      benchmark::RunSpecifiedBenchmarks(&warmup);
    }
  }

  benchmark::RunSpecifiedBenchmarks();
}
