cmake_minimum_required(VERSION 3.15 FATAL_ERROR)
project(benchmark VERSION 0.1.0 LANGUAGES CXX)

add_library(native SHARED src/native.hpp src/native.cpp)
target_include_directories(native PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

add_library(common INTERFACE)
target_include_directories(common INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/src)
target_include_directories(common INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}/submodules/coroutine/interface/coroutine)
target_compile_definitions(common INTERFACE _UNICODE UNICODE WIN32_LEAN_AND_MEAN NOMINMAX)
target_compile_definitions(common INTERFACE TOOLCHAIN_NAME="${TOOLCHAIN_NAME}")
target_link_libraries(common INTERFACE native)

find_package(benchmark CONFIG REQUIRED)
target_link_libraries(common INTERFACE benchmark::benchmark)

add_custom_target(benchmark WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

macro(add_benchmark source)
  get_filename_component(target ${source} NAME_WE)
  add_executable(${target} src/main.cpp ${source})
  target_link_libraries(${target} PRIVATE common)
  add_custom_command(TARGET benchmark POST_BUILD COMMAND $<TARGET_FILE:${target}> USES_TERMINAL)
endmacro()

add_benchmark(src/benchmark/co_result.cpp)
add_benchmark(src/benchmark/error_code.cpp)

if(TOOLCHAIN_HAS_EXCEPTIONS)
  add_benchmark(src/benchmark/exception.cpp)
  add_benchmark(src/benchmark/system_error.cpp)
endif()


