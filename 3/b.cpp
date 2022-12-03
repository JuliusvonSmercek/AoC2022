#include "utils.h"

long long solve(vector<string> &lines) {
  long long result = 0;

  for (int j = 0; j < lines.size(); j += 3) {
    set<char> chars[3];
    for (int k = 0; k < 3; ++k)
      for (int i = 0; i < lines[k + j].size(); ++i) {
        chars[k].insert(lines[k + j][i]);
      }

    vector<char> vec, vec2;
    set_intersection(chars[0].begin(), chars[0].end(), chars[1].begin(),
                     chars[1].end(), std::back_inserter(vec));
    set_intersection(vec.begin(), vec.end(), chars[2].begin(), chars[2].end(),
                     std::back_inserter(vec2));

    char c = vec2[0];
    if ('a' <= c && c <= 'z') {
      result += c - 'a' + 1;
    } else if ('A' <= c && c <= 'Z') {
      result += c - 'A' + 27;
    }
  }

  return result;
}