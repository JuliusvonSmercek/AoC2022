#include "utils.h"

long long solve(vector<string> &lines) {
  long long result = 0;

  for (string &line : lines) {
    stringstream ss(line);
    int a, b, c, d;
    char c1, c2, c3;
    ss >> a >> c1 >> b >> c2 >> c >> c3 >> d;

    if ((a <= c && d <= b) || (c <= a && b <= d) ||
        (a <= c && c <= b && b <= d) || (c <= a && a <= d && d <= b))
      ++result;
  }

  return result;
}