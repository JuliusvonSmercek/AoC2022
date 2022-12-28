#include "utils.h"

long long solve(vector<string> &lines) {
  long long result = 0;

  vector<stack<char>> stacks;
  if (isSample) {
    stacks = vector<stack<char>>(3);
    stacks[0] = stack<char>({'Z', 'N'});
    stacks[1] = stack<char>({'M', 'C', 'D'});
    stacks[2] = stack<char>({'P'});
  } else {
    stacks = vector<stack<char>>(9);
    stacks[0] = stack<char>({'D', 'B', 'J', 'V'});
    stacks[1] = stack<char>({'P', 'V', 'B', 'W', 'R', 'D', 'F'});
    stacks[2] = stack<char>({'R', 'G', 'F', 'L', 'D', 'C', 'W', 'Q'});
    stacks[3] = stack<char>({'W', 'J', 'P', 'M', 'L', 'N', 'D', 'B'});
    stacks[4] = stack<char>({'H', 'N', 'B', 'P', 'C', 'S', 'Q'});
    stacks[5] = stack<char>({'R', 'D', 'B', 'S', 'N', 'G'});
    stacks[6] = stack<char>({'Z', 'B', 'P', 'M', 'Q', 'F', 'S', 'H'});
    stacks[7] = stack<char>({'W', 'L', 'F'});
    stacks[8] = stack<char>({'S', 'V', 'F', 'M', 'R'});
  }

  for (string &line : lines) {
    stringstream ss(line);
    int a, b, c;
    ss >> a >> b >> c;

    stack<char> temp;
    for (int i = 0; i < a; ++i) {
      auto x = stacks[b - 1].top();
      stacks[b - 1].pop();
      temp.push(x);
    }

    while (!temp.empty()) {
      stacks[c - 1].push(temp.top());
      temp.pop();
    }
  }

  for (size_t i = 0; i < stacks.size(); ++i) {
    cout << stacks[i].top();
  }
  cout << '\n';

  return result;
}