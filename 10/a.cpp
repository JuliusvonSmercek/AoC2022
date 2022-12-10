#include "utils.h"

ll cycle(ll &cycles, const ll x) {
  ++cycles;
  return (20 == cycles % 40) ? cycles * x : 0;
}

long long solve(vector<string> &lines) {
  ll x = 1, cycles = 0, sum = 0;

  for (string &line : lines) {
    stringstream ss(line);
    string cmd;
    ss >> cmd;
    if ("addx" == cmd) {
      ll value;
      ss >> value;
      sum += cycle(cycles, x);
      sum += cycle(cycles, x);
      x += value;
    } else if ("noop" == cmd) {
      sum += cycle(cycles, x);
    }
  }

  return sum;
}