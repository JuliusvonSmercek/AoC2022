#include "utils.h"

long long solve(vector<string> &lines) {
  vector<vector<char>> data = readMatrix(lines);
  long long result = 0;

  for (int y = 1; y < data.size() - 1; ++y)
    for (int x = 1; x < data[0].size() - 1; ++x) {
      const int value = data[y][x];
      bool top = true, bottom = true, left = true, right = true;
      for (int i = y - 1; i >= 0; --i)
        if (data[i][x] >= value) top = false;
      for (int i = y + 1; i < data.size(); ++i)
        if (data[i][x] >= value) bottom = false;
      for (int i = x - 1; i >= 0; --i)
        if (data[y][i] >= value) left = false;
      for (int i = x + 1; i < data[0].size(); ++i)
        if (data[y][i] >= value) right = false;
      if (top || bottom || right || left) {
        ++result;
      }
    }

  return 2 * data[0].size() + 2 * data.size() - 4 + result;
}