#pragma once
#include <stdlib.h>

#ifndef NATIVE_API
#  ifdef WIN32
#    ifdef native_EXPORTS
#      define NATIVE_API __declspec(dllexport)
#    else
#      define NATIVE_API __declspec(dllimport)
#    endif
#  else
#    define NATIVE_API
#  endif
#endif

#ifdef __cplusplus
extern "C" {
#endif

NATIVE_API int native_fail(int fail);
NATIVE_API int native_string(const char** data, size_t* size);

#ifdef __cplusplus
}  // extern "C"
#endif
