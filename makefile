# usage: make run|format|clean
#
#  run        - build and execute benchmarks
#  format     - use clang-format on all sources
#  clean      - remove curent build directory
#
MAKEFLAGS += --no-print-directory

SCRIPT	:= $(wildcard toolchains/*.cmake)
RECORD	:= $(patsubst toolchains/%.cmake,%,$(SCRIPT))
TARGET	:= $(patsubst %,build/%/benchmark.exe,$(RECORD))
DEPEND	:= $(patsubst %,build/%/CMakeCache.txt,$(RECORD))
DELETE	:= $(patsubst %,delete/%,$(RECORD))

all: $(TARGET)

run: all $(RECORD)

$(RECORD): %: build/%/benchmark.exe
	$<

$(DEPEND): build/%/CMakeCache.txt: toolchains/%.cmake toolchains/%/lib/benchmark.lib CMakeLists.txt
	cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$< -B $(@D)

$(TARGET): build/%/benchmark.exe: build/%/CMakeCache.txt src/main.cpp
	cmake --build $(@D)

format: toolchains/llvm/bin/clang.exe
	cmake -P res/scripts/format.cmake

clean: $(DELETE)
	cmake -E remove_directory toolchains/msvc
	cmake -E remove_directory toolchains/llvm
	cmake -E remove_directory build

$(DELETE): delete/%:
	cmake -E remove_directory toolchains/src/$*-benchmark
	cmake -E remove_directory toolchains/src/$*-libcxx
	cmake -E remove_directory toolchains/src/$*-compiler-rt
	cmake -E remove_directory toolchains/$*

toolchains/src/llvm:
	git clone --depth 1 https://github.com/llvm/llvm-project $@

toolchains/src/llvm/llvm-patch.log: \
  toolchains/src/llvm
	cmake -P toolchains/src/llvm-patch.cmake

toolchains/src/llvm-build/CMakeCache.txt: \
  toolchains/src/llvm/llvm-patch.log
	cmake -GNinja -DCMAKE_BUILD_TYPE=MinSizeRel \
	  -DCMAKE_INSTALL_PREFIX="$(CURDIR)/toolchains/llvm" \
	  -DLLVM_ENABLE_PROJECTS="lld;clang;clang-tools-extra" \
	  -DLLVM_TARGETS_TO_BUILD="X86" \
	  -DLLVM_ENABLE_UNWIND_TABLES=OFF \
	  -DLLVM_ENABLE_WARNINGS=OFF \
	  -DLLVM_ENABLE_RTTI=OFF \
	  -DLLVM_INCLUDE_BENCHMARKS=OFF \
	  -DLLVM_INCLUDE_EXAMPLES=OFF \
	  -DLLVM_INCLUDE_TESTS=OFF \
	  -DLLVM_INCLUDE_DOCS=OFF \
	  -DCLANG_DEFAULT_STD_C="c99" \
	  -DCLANG_DEFAULT_STD_CXX="cxx2a" \
	  -DCLANG_DEFAULT_CXX_STDLIB="libc++" \
	  -DCLANG_DEFAULT_RTLIB="compiler-rt" \
	  -DCLANG_DEFAULT_LINKER="lld" \
	  -B toolchains/src/llvm-build toolchains/src/llvm/llvm

toolchains/llvm/bin/clang.exe: \
  toolchains/src/llvm-build/CMakeCache.txt
	cmake --build toolchains/src/llvm-build -t \
	  install-clang-stripped \
	  install-clang-format-stripped \
	  install-clang-resource-headers \
	  install-llvm-ar-stripped \
	  install-llvm-ranlib-stripped \
	  install-lld-stripped \
	  install-LTO-stripped \
	  llvm-config
	cmake -E remove -f "toolchains/llvm/bin/ld.lld.exe"
	cmake -E remove -f "toolchains/llvm/bin/ld64.lld.exe"
	cmake -E remove -f "toolchains/llvm/bin/lld.exe"
	cmake -E remove -f "toolchains/llvm/bin/wasm-ld.exe"
	cmake -E remove -f "toolchains/llvm/bin/clang++.exe"
	cmake -E remove -f "toolchains/llvm/bin/clang-cl.exe"
	cmake -E remove -f "toolchains/llvm/bin/clang-cpp.exe"
	cmake -E remove -f "toolchains/llvm/bin/llvm-ranlib.exe"
	cmd /c mklink "toolchains\llvm\bin\clang++.exe" "clang.exe"
	cmd /c mklink "toolchains\llvm\bin\clang-cl.exe" "clang.exe"
	cmd /c mklink "toolchains\llvm\bin\llvm-ranlib.exe" "llvm-ar.exe"

.PRECIOUS: toolchains/src/%-compiler-rt/CMakeCache.txt
toolchains/src/%-compiler-rt/CMakeCache.txt: \
  toolchains/llvm/bin/clang.exe
	cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
	  -DCMAKE_TOOLCHAIN_FILE="$(CURDIR)/toolchains/$*.cmake" \
	  -DCMAKE_INSTALL_PREFIX="$(CURDIR)/toolchains/$*/lib/clang/10.0.0" \
	  -DLLVM_CONFIG_PATH="$(CURDIR)/toolchains/src/llvm-build/bin/llvm-config.exe" \
	  -DCOMPILER_RT_BUILD_SANITIZERS=OFF \
	  -DCOMPILER_RT_BUILD_XRAY=OFF \
	  -DCOMPILER_RT_BUILD_LIBFUZZER=OFF \
	  -DCOMPILER_RT_BUILD_PROFILE=OFF \
	  -DCOMPILER_RT_INCLUDE_TESTS=OFF \
	  -B toolchains/src/$*-compiler-rt toolchains/src/llvm/compiler-rt

.PRECIOUS: toolchains/%/lib/clang/10.0.0/lib/windows/clang_rt.builtins-x86_64.lib
toolchains/%/lib/clang/10.0.0/lib/windows/clang_rt.builtins-x86_64.lib: \
  toolchains/src/%-compiler-rt/CMakeCache.txt
	cmake --build toolchains/src/$*-compiler-rt -t install-compiler-rt-stripped

.PRECIOUS: toolchains/src/%-libcxx/CMakeCache.txt
toolchains/src/%-libcxx/CMakeCache.txt: \
  toolchains/%/lib/clang/10.0.0/lib/windows/clang_rt.builtins-x86_64.lib
	cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
	  -DCMAKE_TOOLCHAIN_FILE="$(CURDIR)/toolchains/$*.cmake" \
	  -DCMAKE_INSTALL_PREFIX="$(CURDIR)/toolchains/$*" \
	  -DLLVM_CONFIG_PATH="$(CURDIR)/toolchains/src/llvm-build/bin/llvm-config.exe" \
	  -DLIBCXX_STANDARD_VER="c++2a" \
	  -DLIBCXX_ENABLE_SHARED=OFF \
	  -DLIBCXX_ENABLE_STATIC=ON \
	  -DLIBCXX_ENABLE_EXPERIMENTAL_LIBRARY=OFF \
	  -DLIBCXX_INCLUDE_BENCHMARKS=OFF \
	  -DLIBCXX_INCLUDE_TESTS=OFF \
	  -DLIBCXX_INCLUDE_DOCS=OFF \
	  -DLIBCXX_HAS_WIN32_THREAD_API=ON \
	  -B toolchains/src/$*-libcxx toolchains/src/llvm/libcxx

.PRECIOUS: toolchains/%/lib/libc++.lib
toolchains/%/lib/libc++.lib: \
  toolchains/src/%-libcxx/CMakeCache.txt
	cmake --build toolchains/src/$*-libcxx -t install-cxx-stripped
	cmd /c mklink "toolchains\$*\lib\c++.lib" "libc++.lib"

.PRECIOUS: toolchains/src/llvm-cxx-%-benchmark/CMakeCache.txt
toolchains/src/llvm-cxx-%-benchmark/CMakeCache.txt: \
  toolchains/llvm-cxx-%/lib/libc++.lib \
  toolchains/src/benchmark-1.5.0
	cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
	  -DCMAKE_TOOLCHAIN_FILE="$(CURDIR)/toolchains/llvm-cxx-$*.cmake" \
	  -DCMAKE_INSTALL_PREFIX="$(CURDIR)/toolchains/llvm-cxx-$*" \
	  -DBENCHMARK_ENABLE_TESTING=OFF \
	  -DBENCHMARK_ENABLE_GTEST_TESTS=OFF \
	  -DBENCHMARK_ENABLE_ASSEMBLY_TESTS=OFF \
	  -DBENCHMARK_ENABLE_EXCEPTIONS=OFF \
	  -B toolchains/src/llvm-cxx-$*-benchmark toolchains/src/benchmark-1.5.0

.PRECIOUS: toolchains/llvm-cxx-%/lib/benchmark.lib
toolchains/llvm-cxx-%/lib/benchmark.lib: \
  toolchains/src/llvm-cxx-%-benchmark/CMakeCache.txt
	cmake --build toolchains/src/llvm-cxx-$*-benchmark -t install

.PRECIOUS: toolchains/src/llvm-stl-%-benchmark/CMakeCache.txt
toolchains/src/llvm-stl-%-benchmark/CMakeCache.txt: \
  toolchains/llvm/bin/clang.exe \
  toolchains/src/benchmark-1.5.0
	cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
	  -DCMAKE_TOOLCHAIN_FILE="$(CURDIR)/toolchains/llvm-stl-$*.cmake" \
	  -DCMAKE_INSTALL_PREFIX="$(CURDIR)/toolchains/llvm-stl-$*" \
	  -DBENCHMARK_ENABLE_TESTING=OFF \
	  -DBENCHMARK_ENABLE_GTEST_TESTS=OFF \
	  -DBENCHMARK_ENABLE_ASSEMBLY_TESTS=OFF \
	  -DBENCHMARK_ENABLE_EXCEPTIONS=OFF \
	  -B toolchains/src/llvm-stl-$*-benchmark toolchains/src/benchmark-1.5.0

.PRECIOUS: toolchains/llvm-stl-%/lib/benchmark.lib
toolchains/llvm-stl-%/lib/benchmark.lib: \
  toolchains/src/llvm-stl-%-benchmark/CMakeCache.txt
	cmake --build toolchains/src/llvm-stl-$*-benchmark -t install

.PRECIOUS: toolchains/src/msvc-stl-%-benchmark/CMakeCache.txt
toolchains/src/msvc-stl-%-benchmark/CMakeCache.txt: \
  toolchains/src/benchmark-1.5.0
	cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
	  -DCMAKE_TOOLCHAIN_FILE="$(CURDIR)/toolchains/msvc-stl-$*.cmake" \
	  -DCMAKE_INSTALL_PREFIX="$(CURDIR)/toolchains/msvc-stl-$*" \
	  -DBENCHMARK_ENABLE_TESTING=OFF \
	  -DBENCHMARK_ENABLE_GTEST_TESTS=OFF \
	  -DBENCHMARK_ENABLE_ASSEMBLY_TESTS=OFF \
	  -DBENCHMARK_ENABLE_EXCEPTIONS=OFF \
	  -B toolchains/src/msvc-stl-$*-benchmark toolchains/src/benchmark-1.5.0

.PRECIOUS: toolchains/msvc-stl-%/lib/benchmark.lib
toolchains/msvc-stl-%/lib/benchmark.lib: \
  toolchains/src/msvc-stl-%-benchmark/CMakeCache.txt
	cmake --build toolchains/src/msvc-stl-$*-benchmark -t install

toolchains/src/benchmark-1.5.0: toolchains/src/benchmark-1.5.0.zip
	cd toolchains/src && cmake -E tar xf benchmark-1.5.0.zip

toolchains/src/benchmark-1.5.0.zip:
	curl -L https://github.com/google/benchmark/archive/v1.5.0.zip -o $@

.PHONY: all run $(RECORD) format clean $(DELETE)
