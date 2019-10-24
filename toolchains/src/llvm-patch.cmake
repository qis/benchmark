file(READ "${CMAKE_CURRENT_LIST_DIR}/llvm/libcxx/CMakeLists.txt" LIBCXX_CMAKELISTS_TXT)

string(REPLACE
  "/FI\\\"\${site_config_path}\\\""
  "-include\${site_config_path}"
  LIBCXX_CMAKELISTS_TXT "${LIBCXX_CMAKELISTS_TXT}")

file(WRITE "${CMAKE_CURRENT_LIST_DIR}/llvm/libcxx/CMakeLists.txt" "${LIBCXX_CMAKELISTS_TXT}")
file(WRITE "${CMAKE_CURRENT_LIST_DIR}/llvm/llvm-patch.log" "SUCCESS")
