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
co_result/success     1.28 ns  1.26 ns  llvm-cxx-speed-no-exceptions
co_result/success     1.28 ns  1.28 ns  llvm-cxx-space-no-exceptions
co_result/success     1.28 ns  1.29 ns  llvm-cxx-space
exception/success     1.49 ns  1.46 ns  llvm-cxx-speed
co_result/success     1.50 ns  1.50 ns  llvm-cxx-speed
exception/success     1.49 ns  1.51 ns  llvm-stl-speed
exception/success     1.76 ns  1.76 ns  llvm-cxx-space
exception/success     1.76 ns  1.76 ns  llvm-stl-space
exception/success     2.12 ns  2.13 ns  msvc-stl-speed
error_code/success    2.34 ns  2.35 ns  llvm-cxx-speed-no-exceptions
error_code/success    2.50 ns  2.51 ns  llvm-cxx-speed
system_error/success  2.55 ns  2.57 ns  llvm-cxx-speed
system_error/success  2.72 ns  2.70 ns  llvm-cxx-space
exception/success     2.79 ns  2.83 ns  msvc-stl-space
error_code/success    3.56 ns  3.53 ns  llvm-cxx-space
error_code/success    4.51 ns  4.59 ns  llvm-cxx-space-no-exceptions
system_error/success  6.62 ns  6.56 ns  llvm-stl-speed
system_error/success  6.81 ns  6.80 ns  msvc-stl-speed
system_error/success  6.98 ns  6.98 ns  llvm-stl-space
system_error/success  8.43 ns  8.37 ns  msvc-stl-space
error_code/success    9.98 ns  10.0 ns  msvc-stl-speed-no-exceptions
error_code/success    10.4 ns  10.5 ns  msvc-stl-speed
error_code/success    11.0 ns  10.9 ns  llvm-stl-speed
error_code/success    11.0 ns  11.0 ns  msvc-stl-space-no-exceptions
error_code/success    11.1 ns  11.2 ns  llvm-stl-speed-no-exceptions
error_code/success    11.9 ns  12.0 ns  llvm-stl-space-no-exceptions
error_code/success    12.3 ns  12.3 ns  llvm-stl-space
error_code/success    12.3 ns  12.3 ns  msvc-stl-space
co_result/success     50.2 ns  50.0 ns  msvc-stl-space-no-exceptions
co_result/success     50.5 ns  50.0 ns  msvc-stl-speed
co_result/success     50.0 ns  50.2 ns  msvc-stl-speed-no-exceptions
co_result/success     51.1 ns  50.2 ns  msvc-stl-space
--------------------------------------------------------------------
co_result/failure     1.06 ns  1.07 ns  llvm-cxx-speed-no-exceptions
co_result/failure     1.27 ns  1.26 ns  llvm-cxx-speed
co_result/failure     1.49 ns  1.46 ns  llvm-cxx-space-no-exceptions
co_result/failure     1.51 ns  1.51 ns  llvm-cxx-space
error_code/failure    1.91 ns  1.90 ns  llvm-cxx-speed
error_code/failure    1.92 ns  1.90 ns  llvm-cxx-speed-no-exceptions
error_code/failure    3.02 ns  3.05 ns  llvm-cxx-space
error_code/failure    4.71 ns  4.71 ns  llvm-cxx-space-no-exceptions
error_code/failure    9.90 ns  9.84 ns  msvc-stl-speed-no-exceptions
error_code/failure    10.2 ns  10.0 ns  llvm-stl-speed
error_code/failure    10.2 ns  10.0 ns  msvc-stl-speed
error_code/failure    10.2 ns  10.3 ns  llvm-stl-speed-no-exceptions
error_code/failure    10.6 ns  10.5 ns  msvc-stl-space-no-exceptions
error_code/failure    11.3 ns  11.2 ns  llvm-stl-space
error_code/failure    11.4 ns  11.5 ns  msvc-stl-space
error_code/failure    11.6 ns  11.7 ns  llvm-stl-space-no-exceptions
co_result/failure     51.1 ns  50.2 ns  msvc-stl-space-no-exceptions
co_result/failure     51.5 ns  51.6 ns  msvc-stl-speed
co_result/failure     51.5 ns  51.6 ns  msvc-stl-speed-no-exceptions
co_result/failure     52.4 ns  53.1 ns  msvc-stl-space
exception/failure     1523 ns  1500 ns  llvm-stl-space
exception/failure     1546 ns  1535 ns  llvm-cxx-space
exception/failure     1552 ns  1569 ns  llvm-cxx-speed
exception/failure     1559 ns  1569 ns  llvm-stl-speed
exception/failure     1597 ns  1604 ns  msvc-stl-space
exception/failure     1609 ns  1611 ns  msvc-stl-speed
system_error/failure  1602 ns  1604 ns  llvm-cxx-speed
system_error/failure  1612 ns  1604 ns  llvm-stl-speed
system_error/failure  1642 ns  1639 ns  llvm-stl-space
system_error/failure  1642 ns  1650 ns  llvm-cxx-space
system_error/failure  1714 ns  1726 ns  msvc-stl-space
system_error/failure  1729 ns  1726 ns  msvc-stl-speed
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
636416 msvc-stl-speed/system_error
636928 llvm-stl-speed/exception
638464 llvm-stl-speed-no-exceptions/error_code
642048 llvm-stl-speed/error_code
642560 llvm-cxx-speed/co_result
643072 llvm-cxx-speed/exception
644096 llvm-cxx-speed/error_code
645120 llvm-cxx-speed/system_error
645632 llvm-stl-speed/system_error
```
