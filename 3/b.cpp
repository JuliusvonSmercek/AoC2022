#include "utils.h"

long long solve(vector<string> &lines) {
  long long result = 0;

  for (int j = 0; j < lines.size(); j += 3) {
    const char c =
        intersection(chars(lines[0 + j]),
                     intersection(chars(lines[1 + j]), chars(lines[2 + j])))[0];
    if ('a' <= c && c <= 'z') {
      result += c - 'a' + 1;
    } else if ('A' <= c && c <= 'Z') {
      result += c - 'A' + 27;
    }
  }

  return result;
}