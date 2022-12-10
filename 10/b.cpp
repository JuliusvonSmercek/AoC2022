#include "utils.h"

ll cycle(ll &cycles, vector<char> &output, const ll x) {
  output[cycles] = (abs(cycles % 40 - x) <= 1) ? '#' : '.';
  ++cycles;
  return (20 == cycles % 40) ? cycles * x : 0;
}

long long solve(vector<string> &lines) {
  ll x = 1, cycles = 0, sum = 0;
  vector<char> output(240, '+');

  for (string &line : lines) {
    stringstream ss(line);
    string cmd;
    ss >> cmd;
    if ("addx" == cmd) {
      ll value;
      ss >> value;
      sum += cycle(cycles, output, x);
      sum += cycle(cycles, output, x);
      x += value;
    } else if ("noop" == cmd) {
      sum += cycle(cycles, output, x);
    }
  }

  for (int i = 0; i < 6; ++i) {
    for (int j = 0; j < 40; ++j) cout << output[40 * i + j];
    cout << endl;
  }

  return sum;
}