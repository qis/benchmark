cmake_minimum_required(VERSION 3.15 FATAL_ERROR)
project(benchmark VERSION 0.1.0 LANGUAGES CXX)

add_library(native SHARED src/native.hpp src/native.cpp)
target_include_directories(native PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

add_executable(${PROJECT_NAME} src/main.cpp)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)
target_compile_definitions(${PROJECT_NAME} PRIVATE _UNICODE UNICODE WIN32_LEAN_AND_MEAN NOMINMAX)
target_compile_definitions(${PROJECT_NAME} PRIVATE TOOLCHAIN_NAME="${TOOLCHAIN_NAME}")
target_link_libraries(${PROJECT_NAME} PRIVATE native)

if(TOOLCHAIN_HAS_COROUTINES)
  target_sources(${PROJECT_NAME} PRIVATE src/benchmark/co_result.cpp)
endif()

if(TOOLCHAIN_HAS_EXCEPTIONS)
  target_sources(${PROJECT_NAME} PRIVATE src/benchmark/exception.cpp)
endif()

find_package(benchmark CONFIG REQUIRED)
target_link_libraries(${PROJECT_NAME} PRIVATE benchmark::benchmark)
