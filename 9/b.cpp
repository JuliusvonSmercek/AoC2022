#include "utils.h"

long long solve(vector<string> &lines) {
  set<pair<int, int>> visited;

  vector<pair<int /*y*/, int /*x*/>> T(10, {0, 0});  // T[0] == T[0]
  for (string &line : lines) {
    stringstream ss(line);
    char letter;
    int number;
    ss >> letter >> number;
    for (int i = 0; i < number; ++i) {
      if ('R' == letter) {
        ++T[0].second;
      } else if ('L' == letter) {
        --T[0].second;
      } else if ('U' == letter) {
        ++T[0].first;
      } else if ('D' == letter) {
        --T[0].first;
      }

      for (size_t k = 1; k < T.size(); ++k) {
        int dx = (T[k - 1].second - T[k].second),
            dy = (T[k - 1].first - T[k].first);

        if (1.5 < sqrt(dx * dx + dy * dy)) {
          if (0 < dx)
            T[k].second++;
          else if (dx < 0)
            T[k].second--;

          if (0 < dy)
            T[k].first++;
          else if (dy < 0)
            T[k].first--;
        }
      }
      visited.insert(T[T.size() - 1]);
    }
  }

  return visited.size();
}