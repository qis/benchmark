find_program(CLANG_FORMAT NAMES clang-format PATHS "${CMAKE_CURRENT_LIST_DIR}/../../toolchains/llvm/bin")

if(NOT CLANG_FORMAT)
  message(FATAL_ERROR "Could not find executable: clang-format")
endif()

file(GLOB_RECURSE sources src/*.hpp src/*.h src/*.cpp src/*.c)
execute_process(COMMAND ${CLANG_FORMAT} -i ${sources})
