#include "utils.h"

long long solve(vector<string> &lines) {
  vector<vector<char>> data = readMatrix(lines);
  long long result = 0;

  for (int y = 1; y < data.size() - 1; ++y)
    for (int x = 1; x < data[0].size() - 1; ++x) {
      const int value = data[y][x];
      long long top = 1, bottom = 1, left = 1, right = 1;
      for (int i = 1; i < y && data[y - i][x] < value; ++i) top = i + 1;
      for (int i = 1; i < x && data[y][x - i] < value; ++i) left = i + 1;
      for (int i = 1; y + i < data.size() - 1 && data[y + i][x] < value; ++i)
        bottom = i + 1;
      for (int i = 1; x + i < data[0].size() - 1 && data[y][x + i] < value; ++i)
        right = i + 1;
      result = max(result, top * bottom * left * right);
    }

  return result;
}