#include "utils.h"

long long solve(vector<string> &lines) {
  vector<vector<int>> data = readInput<int>(lines);
  long long result = 0;

  for (auto items : data) {
    long long sum = 0;
    for (auto item : items) sum += item;
    result = max(result, sum);
  }

  return result;
}