#include "utils.h"

long long solve(vector<string> &lines) {
  set<pair<int, int>> visited;

  pair<int /*y*/, int /*x*/> H{0, 0}, T{0, 0};
  for (string &line : lines) {
    stringstream ss(line);
    char letter;
    int number;
    ss >> letter >> number;
    for (int i = 0; i < number; ++i) {
      if ('R' == letter) {
        if (1 == H.second - T.second) {
          T = H;
        }
        ++H.second;
      } else if ('L' == letter) {
        if (-1 == H.second - T.second) {
          T = H;
        }
        --H.second;
      } else if ('U' == letter) {
        if (1 == H.first - T.first) {
          T = H;
        }
        ++H.first;
      } else if ('D' == letter) {
        if (-1 == H.first - T.first) {
          T = H;
        }
        --H.first;
      }
      visited.insert(T);
    }
  }

  return visited.size();
}