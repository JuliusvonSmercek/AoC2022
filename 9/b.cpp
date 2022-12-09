#include "utils.h"

#define y first
#define x second

long long solve(vector<string> &lines) {
  set<pair<int, int>> visited;

  vector<pair<int /*y*/, int /*x*/>> T(10, {0, 0});
  for (string &line : lines) {
    stringstream ss(line);
    char letter;
    int number;
    ss >> letter >> number;
    for (int i = 0; i < number; ++i) {
      if ('R' == letter) {
        ++T[0].x;
      } else if ('L' == letter) {
        --T[0].x;
      } else if ('U' == letter) {
        ++T[0].y;
      } else if ('D' == letter) {
        --T[0].y;
      }

      for (size_t k = 1; k < T.size(); ++k) {
        const int dx = T[k - 1].x - T[k].x,
            dy = T[k - 1].y - T[k].y;

        if (1 < abs(dx) || 1 < abs(dy)) {
          if (0 < dx)
            ++T[k].x;
          else if (dx < 0)
            --T[k].x;

          if (0 < dy)
            ++T[k].y;
          else if (dy < 0)
            --T[k].y;
        }
      }
      visited.insert(T[T.size() - 1]);
    }
  }

  return visited.size();
}