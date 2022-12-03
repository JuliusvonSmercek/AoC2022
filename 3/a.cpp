#include "utils.h"

long long solve(vector<string> &lines) {
  long long result = 0;

  for (string &line : lines) {
    set<char> first, second;
    for (char c : line.substr(0, line.size() / 2)) {
      first.insert(c);
    }
    for (char c : line.substr(line.size() / 2, line.size() / 2)) {
      second.insert(c);
    }

    vector<char> vec;
    set_intersection(first.begin(), first.end(), second.begin(), second.end(),
                     std::back_inserter(vec));

    char c = vec[0];
    if ('a' <= c && c <= 'z') {
      result += c - 'a' + 1;
    } else if ('A' <= c && c <= 'Z') {
      result += c - 'A' + 27;
    }
  }

  return result;
}