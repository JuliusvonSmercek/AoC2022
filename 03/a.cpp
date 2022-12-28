#include "utils.h"

long long solve(vector<string> &lines) {
  long long result = 0;

  for (string &line : lines) {
    const char c =
        intersection(chars(line.substr(0, line.size() / 2)),
                     chars(line.substr(line.size() / 2, line.size() / 2)))[0];
    if ('a' <= c && c <= 'z') {
      result += c - 'a' + 1;
    } else if ('A' <= c && c <= 'Z') {
      result += c - 'A' + 27;
    }
  }

  return result;
}