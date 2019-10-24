# Benchmark
Performance comparison of C++ error handling mechanisms.

## Requirements
The benchmarks currently support only Windows.

- Windows 10 with Symlink support for the project directory.
- Visual Studio 2019 with Desktop development with C++ selected.
- CMake >= 3.15 in `PATH`.
- Ninja in `PATH`.
- Git in `PATH`.

## Instructions
Everything is handled by the [makefile](makefile).

- The [make.cmd](make.cmd) script is a wrapper for [toolchains/make/make.exe](toolchains/make/make.exe).
- The file `toolchains/make/make.exe` file is a copy of <http://www.equation.com/servlet/equation.cmd?fa=make>.
- Running any make command except `make clean` will download and build [LLVM](https://llvm.org/).
- Build and run all benchmarks with the `make run` command.

## Results
Run on Intel Core i7-8700K.

```
12 x 3696 MHz
L1 Data 32K (x6)
L1 Instruction 32K (x6)
L2 Unified 262K (x6)
L3 Unified 12582K (x1)
```

Sorted by toolchain and method.

```
-----------------------------------------------------------------------------------------
Benchmark                  Time             CPU   Iterations Toolchain
-----------------------------------------------------------------------------------------
co_result/success       2.52 ns         2.55 ns    263529412 llvm-cxx-space
co_result/failure       1.92 ns         1.90 ns    344615385 llvm-cxx-space
exception/success       1.77 ns         1.76 ns    373333333 llvm-cxx-space
exception/failure       1513 ns         1500 ns       448000 llvm-cxx-space
-----------------------------------------------------------------------------------------
co_result/success       50.7 ns         50.0 ns     10000000 msvc-stl-speed
co_result/failure       51.6 ns         51.6 ns     10000000 msvc-stl-speed
exception/success       2.15 ns         2.15 ns    320000000 msvc-stl-speed
exception/failure       1613 ns         1611 ns       407273 msvc-stl-speed
-----------------------------------------------------------------------------------------
co_result/success       56.1 ns         55.8 ns     11200000 msvc-stl-space
co_result/failure       57.4 ns         57.8 ns     10000000 msvc-stl-space
exception/success       2.68 ns         2.73 ns    263529412 msvc-stl-space
exception/failure       1594 ns         1604 ns       448000 msvc-stl-space
-----------------------------------------------------------------------------------------
co_result/success       1.96 ns         1.95 ns    320000000 llvm-cxx-space-no-exceptions
co_result/failure       1.27 ns         1.28 ns    560000000 llvm-cxx-space-no-exceptions
-----------------------------------------------------------------------------------------
co_result/success       52.9 ns         51.6 ns     11200000 msvc-stl-speed-no-exceptions
co_result/failure       49.9 ns         50.0 ns     10000000 msvc-stl-speed-no-exceptions
-----------------------------------------------------------------------------------------
co_result/success       52.6 ns         53.1 ns     10000000 msvc-stl-space-no-exceptions
co_result/failure       48.8 ns         49.7 ns     14451613 msvc-stl-space-no-exceptions
-----------------------------------------------------------------------------------------
co_result/success       1.28 ns         1.26 ns    497777778 llvm-cxx-speed
co_result/failure       1.07 ns         1.07 ns    640000000 llvm-cxx-speed
exception/success       1.49 ns         1.50 ns    448000000 llvm-cxx-speed
exception/failure       1532 ns         1535 ns       448000 llvm-cxx-speed
-----------------------------------------------------------------------------------------
exception/success       1.78 ns         1.76 ns    373333333 llvm-stl-space
exception/failure       1540 ns         1535 ns       448000 llvm-stl-space
-----------------------------------------------------------------------------------------
co_result/success       1.28 ns         1.28 ns    560000000 llvm-cxx-speed-no-exceptions
co_result/failure       1.07 ns         1.07 ns    640000000 llvm-cxx-speed-no-exceptions
-----------------------------------------------------------------------------------------
exception/success       1.51 ns         1.50 ns    448000000 llvm-stl-speed
exception/failure       1556 ns         1535 ns       448000 llvm-stl-speed
-----------------------------------------------------------------------------------------
```

Sorted by success/failure and CPU time.

```
-----------------------------------------------------------------------------------------
Benchmark                  Time             CPU   Iterations Toolchain
-----------------------------------------------------------------------------------------
co_result/success       1.28 ns         1.26 ns    497777778 llvm-cxx-speed
co_result/success       1.28 ns         1.28 ns    560000000 llvm-cxx-speed-no-exceptions
exception/success       1.49 ns         1.50 ns    448000000 llvm-cxx-speed
exception/success       1.51 ns         1.50 ns    448000000 llvm-stl-speed
exception/success       1.77 ns         1.76 ns    373333333 llvm-cxx-space
exception/success       1.78 ns         1.76 ns    373333333 llvm-stl-space
co_result/success       1.96 ns         1.95 ns    320000000 llvm-cxx-space-no-exceptions
exception/success       2.15 ns         2.15 ns    320000000 msvc-stl-speed
co_result/success       2.52 ns         2.55 ns    263529412 llvm-cxx-space
exception/success       2.68 ns         2.73 ns    263529412 msvc-stl-space
co_result/success       50.7 ns         50.0 ns     10000000 msvc-stl-speed
co_result/success       52.9 ns         51.6 ns     11200000 msvc-stl-speed-no-exceptions
co_result/success       52.6 ns         53.1 ns     10000000 msvc-stl-space-no-exceptions
co_result/success       56.1 ns         55.8 ns     11200000 msvc-stl-space
-----------------------------------------------------------------------------------------
co_result/failure       1.07 ns         1.07 ns    640000000 llvm-cxx-speed
co_result/failure       1.07 ns         1.07 ns    640000000 llvm-cxx-speed-no-exceptions
co_result/failure       1.27 ns         1.28 ns    560000000 llvm-cxx-space-no-exceptions
co_result/failure       1.92 ns         1.90 ns    344615385 llvm-cxx-space
co_result/failure       48.8 ns         49.7 ns     14451613 msvc-stl-space-no-exceptions
co_result/failure       49.9 ns         50.0 ns     10000000 msvc-stl-speed-no-exceptions
co_result/failure       51.6 ns         51.6 ns     10000000 msvc-stl-speed
co_result/failure       57.4 ns         57.8 ns     10000000 msvc-stl-space
exception/failure       1513 ns         1500 ns       448000 llvm-cxx-space
exception/failure       1532 ns         1535 ns       448000 llvm-cxx-speed
exception/failure       1540 ns         1535 ns       448000 llvm-stl-space
exception/failure       1556 ns         1535 ns       448000 llvm-stl-speed
exception/failure       1613 ns         1611 ns       407273 msvc-stl-speed
exception/failure       1594 ns         1604 ns       448000 msvc-stl-space
-----------------------------------------------------------------------------------------
```
