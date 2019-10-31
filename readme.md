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

- The [make.cmd](make.cmd) script is a wrapper for <http://www.equation.com/servlet/equation.cmd?fa=make>.
- Running any make command except `make clean` will download and build [LLVM](https://llvm.org/).
- Build and run all benchmarks with the `make run` command.

## Results
Intel Core i7-8700K.

```
12 x 3696 MHz
L1 Data 32K (x6)
L1 Instruction 32K (x6)
L2 Unified 262K (x6)
L3 Unified 12582K (x1)

--------------------------------------------------------------------
Benchmark                Time      CPU  Toolchain
--------------------------------------------------------------------
co_result/success     1.42 ns  1.42 ns  llvm-stl-space
co_result/success     1.45 ns  1.46 ns  llvm-stl-space-no-exceptions
co_result/success     1.49 ns  1.50 ns  llvm-cxx-space
exception/success     1.49 ns  1.50 ns  llvm-stl-speed
co_result/success     1.50 ns  1.50 ns  llvm-stl-speed
co_result/success     1.51 ns  1.50 ns  llvm-cxx-speed-no-exceptions
co_result/success     1.63 ns  1.65 ns  llvm-stl-speed-no-exceptions
co_result/success     1.67 ns  1.67 ns  llvm-cxx-space-no-exceptions
co_result/success     1.77 ns  1.76 ns  llvm-cxx-speed
exception/success     1.84 ns  1.85 ns  llvm-cxx-speed
exception/success     1.99 ns  1.99 ns  llvm-stl-space
exception/success     2.11 ns  2.13 ns  llvm-cxx-space
exception/success     2.28 ns  2.25 ns  msvc-stl-speed
error_code/success    2.52 ns  2.49 ns  llvm-cxx-speed-no-exceptions
error_code/success    2.90 ns  2.85 ns  llvm-cxx-speed
system_error/success  3.10 ns  3.07 ns  llvm-cxx-space
exception/success     3.07 ns  3.15 ns  msvc-stl-space
system_error/success  3.19 ns  3.25 ns  llvm-cxx-speed
error_code/success    3.43 ns  3.45 ns  llvm-cxx-space-no-exceptions
error_code/success    3.92 ns  3.92 ns  llvm-cxx-space
system_error/success  6.67 ns  6.63 ns  llvm-stl-speed
system_error/success  7.34 ns  7.32 ns  llvm-stl-space
system_error/success  8.05 ns  7.95 ns  msvc-stl-speed
system_error/success  9.07 ns  9.21 ns  msvc-stl-space
error_code/success    10.3 ns  10.3 ns  llvm-stl-speed
error_code/success    11.2 ns  11.0 ns  msvc-stl-speed
error_code/success    11.3 ns  11.4 ns  msvc-stl-space-no-exceptions
error_code/success    11.7 ns  11.7 ns  msvc-stl-speed-no-exceptions
error_code/success    11.8 ns  11.7 ns  llvm-stl-speed-no-exceptions
error_code/success    13.1 ns  13.2 ns  llvm-stl-space-no-exceptions
error_code/success    13.9 ns  14.1 ns  msvc-stl-space
error_code/success    14.4 ns  14.5 ns  llvm-stl-space
co_result/success     50.3 ns  50.2 ns  msvc-stl-speed
co_result/success     53.7 ns  54.4 ns  msvc-stl-space
co_result/success     54.0 ns  54.4 ns  msvc-stl-speed-no-exceptions
co_result/success     55.9 ns  55.8 ns  msvc-stl-space-no-exceptions
--------------------------------------------------------------------
co_result/failure     1.20 ns  1.19 ns  llvm-cxx-speed-no-exceptions
co_result/failure     1.39 ns  1.38 ns  llvm-stl-space-no-exceptions
co_result/failure     1.47 ns  1.46 ns  llvm-cxx-speed
co_result/failure     1.50 ns  1.50 ns  llvm-stl-speed-no-exceptions
co_result/failure     1.54 ns  1.53 ns  llvm-stl-speed
co_result/failure     1.72 ns  1.72 ns  llvm-cxx-space
co_result/failure     1.75 ns  1.73 ns  llvm-stl-space
co_result/failure     1.75 ns  1.76 ns  llvm-cxx-space-no-exceptions
error_code/failure    2.14 ns  2.15 ns  llvm-cxx-speed-no-exceptions
error_code/failure    2.20 ns  2.18 ns  llvm-cxx-speed
error_code/failure    3.27 ns  3.22 ns  llvm-cxx-space-no-exceptions
error_code/failure    3.50 ns  3.45 ns  llvm-cxx-space
error_code/failure    10.9 ns  11.0 ns  msvc-stl-speed-no-exceptions
error_code/failure    11.2 ns  11.2 ns  llvm-stl-speed
error_code/failure    11.4 ns  11.2 ns  llvm-stl-speed-no-exceptions
error_code/failure    11.7 ns  11.6 ns  msvc-stl-speed
error_code/failure    12.5 ns  12.6 ns  llvm-stl-space-no-exceptions
error_code/failure    12.6 ns  12.6 ns  msvc-stl-space-no-exceptions
error_code/failure    13.0 ns  13.1 ns  msvc-stl-space
error_code/failure    13.2 ns  13.1 ns  llvm-stl-space
co_result/failure     54.5 ns  54.4 ns  msvc-stl-speed
co_result/failure     56.4 ns  55.8 ns  msvc-stl-space-no-exceptions
co_result/failure     57.0 ns  57.2 ns  msvc-stl-speed-no-exceptions
co_result/failure     58.2 ns  58.6 ns  msvc-stl-space
exception/failure     1689 ns  1674 ns  msvc-stl-space
exception/failure     1692 ns  1674 ns  llvm-cxx-speed
exception/failure     1683 ns  1688 ns  llvm-stl-space
exception/failure     1704 ns  1726 ns  llvm-cxx-space
system_error/failure  1796 ns  1758 ns  llvm-stl-speed
exception/failure     1769 ns  1803 ns  llvm-stl-speed
exception/failure     1808 ns  1814 ns  msvc-stl-speed
system_error/failure  1827 ns  1842 ns  llvm-stl-space
system_error/failure  1829 ns  1842 ns  llvm-cxx-speed
system_error/failure  1836 ns  1842 ns  llvm-cxx-space
system_error/failure  1922 ns  1904 ns  msvc-stl-space
system_error/failure  1960 ns  1950 ns  msvc-stl-speed
--------------------------------------------------------------------
```

Binary size.

```
456192 llvm-cxx-space-no-exceptions/co_result
459264 llvm-cxx-space-no-exceptions/error_code
514560 llvm-cxx-space/co_result
514560 llvm-cxx-space/exception
516096 llvm-cxx-space/error_code
516608 llvm-cxx-space/system_error
562688 llvm-cxx-speed-no-exceptions/co_result
567296 llvm-cxx-speed-no-exceptions/error_code
570880 llvm-stl-space-no-exceptions/co_result
570880 llvm-stl-space/co_result
571392 llvm-stl-space/exception
572416 llvm-stl-space-no-exceptions/error_code
575488 llvm-stl-space/error_code
578048 llvm-stl-space/system_error
579584 msvc-stl-space-no-exceptions/co_result
581120 msvc-stl-space-no-exceptions/error_code
589312 msvc-stl-space/exception
589824 msvc-stl-space/co_result
594432 msvc-stl-space/error_code
594944 msvc-stl-space/system_error
623104 msvc-stl-speed-no-exceptions/co_result
625152 msvc-stl-speed-no-exceptions/error_code
633856 msvc-stl-speed/exception
634368 msvc-stl-speed/co_result
635904 msvc-stl-speed/error_code
636416 llvm-stl-speed-no-exceptions/co_result
636416 llvm-stl-speed/co_result
636416 msvc-stl-speed/system_error
636928 llvm-stl-speed/exception
638976 llvm-stl-speed-no-exceptions/error_code
642048 llvm-stl-speed/error_code
642560 llvm-cxx-speed/co_result
643072 llvm-cxx-speed/exception
644096 llvm-cxx-speed/error_code
645120 llvm-cxx-speed/system_error
645120 llvm-stl-speed/system_error
```
