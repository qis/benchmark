include_guard(GLOBAL)

get_filename_component(TOOLCHAIN_NAME "${CMAKE_CURRENT_LIST_FILE}" NAME_WE)
set(TOOLCHAIN_TEXT "LLVM, LIBC++, SPEED, EXCEPTIONS ENABLED" CACHE STRING "")
set(TOOLCHAIN_HAS_COROUTINES ON CACHE STRING "")
set(TOOLCHAIN_HAS_EXCEPTIONS ON CACHE STRING "")

set(CMAKE_C_STANDARD 11 CACHE STRING "")
set(CMAKE_C_STANDARD_REQUIRED ON CACHE STRING "")
set(CMAKE_C_EXTENSIONS OFF CACHE STRING "")

set(CMAKE_CXX_STANDARD 20 CACHE STRING "")
set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE STRING "")
set(CMAKE_CXX_EXTENSIONS OFF CACHE STRING "")

set(CMAKE_AR "${CMAKE_CURRENT_LIST_DIR}/llvm/bin/llvm-ar.exe" CACHE STRING "")
set(CMAKE_RANLIB "${CMAKE_CURRENT_LIST_DIR}/llvm/bin/llvm-ranlib.exe" CACHE STRING "")
set(CMAKE_C_COMPILER "${CMAKE_CURRENT_LIST_DIR}/llvm/bin/clang.exe" CACHE STRING "")
set(CMAKE_CXX_COMPILER "${CMAKE_CURRENT_LIST_DIR}/llvm/bin/clang++.exe" CACHE STRING "")
set(CMAKE_RC_COMPILER "rc.exe" CACHE STRING "")

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded" CACHE STRING "")

get_property(_CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE)
if(NOT _CMAKE_IN_TRY_COMPILE)
  set(LLVM_FLAGS "-mavx2 -ffast-math -fms-compatibility-version=19.23 -Xclang -flto-visibility-public-std")
  set(LLVM_FLAGS_RELEASE "-O3 -fmerge-all-constants -D_MT -Xclang --dependent-lib=libcmt -DNDEBUG")

  set(CMAKE_C_FLAGS "${LLVM_FLAGS} -flto" CACHE STRING "")
  
  if(CMAKE_SOURCE_DIR MATCHES "toolchains/src/benchmark")
    set(CMAKE_CXX_FLAGS "${LLVM_FLAGS} -flto -fwhole-program-vtables -fno-exceptions -fno-rtti" CACHE STRING "")
  else()
    set(CMAKE_CXX_FLAGS "${LLVM_FLAGS} -flto -fwhole-program-vtables -fexceptions -frtti" CACHE STRING "")
  endif()

  set(CMAKE_C_FLAGS_RELEASE "${LLVM_FLAGS_RELEASE}" CACHE STRING "")
  set(CMAKE_CXX_FLAGS_RELEASE "${LLVM_FLAGS_RELEASE} -fcoroutines-ts" CACHE STRING "")

  set(CMAKE_C_FLAGS_RELEASE_INIT "" CACHE STRING "")
  set(CMAKE_CXX_FLAGS_RELEASE_INIT "" CACHE STRING "")

  set(CMAKE_STATIC_LINKER_FLAGS "" CACHE STRING "")
  set(CMAKE_SHARED_LINKER_FLAGS "" CACHE STRING "")
  set(CMAKE_EXE_LINKER_FLAGS "" CACHE STRING "")

  set(CMAKE_STATIC_LINKER_FLAGS_RELEASE "" CACHE STRING "")
  set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "-flto -Wl,/DEBUG:NONE,/OPT:REF,/OPT:ICF" CACHE STRING "")
  set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-flto -Wl,/DEBUG:NONE,/OPT:REF,/OPT:ICF" CACHE STRING "")

  set(CMAKE_RC_FLAGS "-nologo /c65001" CACHE STRING "")

  list(INSERT CMAKE_SYSTEM_PREFIX_PATH 0 "${CMAKE_CURRENT_LIST_DIR}/${TOOLCHAIN_NAME}/lib/cmake")
  include_directories(BEFORE "${CMAKE_CURRENT_LIST_DIR}/${TOOLCHAIN_NAME}/include")  
  link_directories(BEFORE "${CMAKE_CURRENT_LIST_DIR}/${TOOLCHAIN_NAME}/lib")

  if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${TOOLCHAIN_NAME}/lib/libc++.lib")
    include_directories(BEFORE SYSTEM "${CMAKE_CURRENT_LIST_DIR}/${TOOLCHAIN_NAME}/include/c++/v1")
  endif()

  add_definitions(/DWIN32 /D_WINDOWS /D_WIN32_WINNT=0x0A00 /DWINVER=0x0A00)
  add_definitions(/D_CRT_SECURE_NO_DEPRECATE /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_DEPRECATE)
  add_definitions(/D_ATL_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_WARNINGS)
  add_definitions(/D_CRT_STDIO_ISO_WIDE_SPECIFIERS=1)
endif()
