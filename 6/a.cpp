#include "utils.h"

long long solve(vector<string> &lines) {
  const int numChars = 4;
  for (size_t pos = 0; pos < lines[0].size() - numChars; ++pos) {
    if (chars(lines[0].substr(pos, numChars)).size() == numChars) {
      return pos + numChars;
    }
  }

  return -1;
}