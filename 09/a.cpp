#include "utils.h"

#define y first
#define x second

long long solve(vector<string> &lines) {
  set<pair<int, int>> visited;

  pair<int /*y*/, int /*x*/> H{0, 0}, T{0, 0};
  for (string &line : lines) {
    stringstream ss(line);
    char letter;
    int number;
    ss >> letter >> number;
    for (int i = 0; i < number; ++i) {
      const int dx = H.x - T.x, dy = H.y - T.y;

      if ('R' == letter) {
        if (1 == dx) {
          T = H;
        }
        ++H.x;
      } else if ('L' == letter) {
        if (-1 == dx) {
          T = H;
        }
        --H.x;
      } else if ('U' == letter) {
        if (1 == dy) {
          T = H;
        }
        ++H.y;
      } else if ('D' == letter) {
        if (-1 == dy) {
          T = H;
        }
        --H.y;
      }
      visited.insert(T);
    }
  }

  return visited.size();
}