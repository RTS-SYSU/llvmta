#ifndef __DUMP_STACK_TRACE__
#define __DUMP_STACK_TRACE__

#include <cstdio>
#include <cstdlib>
#include <execinfo.h>

inline void DumpTraceBack(const char *funcName) {
  const int size = 200;
  void *buffer[size];
  char **strings=NULL;

  int nptrs = backtrace(buffer, size);
  fprintf(stderr, "Func: %s, backtrace() get %d address\n", funcName, nptrs);

  strings = backtrace_symbols(buffer, nptrs);

  if (strings) {
    for (int i = 0; i < nptrs; ++i) {
      fprintf(stderr, "Dep: %d, get Caller: %s\n", i + 1, strings[i]);
    }
    free(strings);
  }
}

#endif