#include "utils.h"

long long solve(vector<string> &lines) {
  vector<vector<int>> data = readInput<int>(lines);
  long long result = 0;

  vector<long long> maxN;
  for (auto items : data) {
    long long sum = 0;
    for (auto item : items) sum += item;
    maxN.push_back(sum);
  }
  sort(maxN.begin(), maxN.end());
  result = maxN[maxN.size() - 1] + maxN[maxN.size() - 2] + maxN[maxN.size() - 3];

  return result;
}