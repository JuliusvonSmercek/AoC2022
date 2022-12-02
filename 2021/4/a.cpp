#include "utils.h"

int check(set<string> &idtf) {
  for (auto item : {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"})
    if (idtf.find(item) == idtf.end()) return 0;
  return 1;
}

long long solve(vector<string> &lines) {
  vector<vector<string>> data = readInput<string>(lines);
  long long result = 0;

  for (auto item : data) {
    set<string> idtf;
    for (string str : item) idtf.insert(str.substr(0, 3));
    result += check(idtf);
  }

  return result;
}