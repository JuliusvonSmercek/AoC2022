#include "utils.h"

long long solve(vector<string> &lines) {
  long long result = 0;

  for (string &line : lines) {
    stringstream ss(line);
    char abc, xyz;
    ss >> abc >> xyz;
    const int a = abc - 'A', x = xyz - 'X';
    result += 3 * ((4 + x - a) % 3) + 1 + x;
  }

  return result;
}