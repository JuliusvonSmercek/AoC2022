#include "utils.h"

int check(set<string> &idtf) {
  for (auto item : {"byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"})
    if (idtf.find(item) == idtf.end()) return 0;
  return 1;
}

bool checkValue(string key, string value) {
  if ("byr" == key) {
    return regex_match(value, regex("[0-9]{4}")) && 1920 <= stoi(value) &&
           stoi(value) <= 2002;
  } else if ("iyr" == key) {
    return regex_match(value, regex("[0-9]{4}")) && 2010 <= stoi(value) &&
           stoi(value) <= 2020;
  } else if ("eyr" == key) {
    return regex_match(value, regex("[0-9]{4}")) && 2020 <= stoi(value) &&
           stoi(value) <= 2030;
  } else if ("hgt" == key) {
    if (regex_match(value, regex("[0-9]{3}cm"))) {
      int num = stoi(value.substr(0, 3));
      return 150 <= num && num <= 193;
    } else if (regex_match(value, regex("[0-9]{2}in"))) {
      int num = stoi(value.substr(0, 2));
      return 59 <= num && num <= 76;
    }
    return false;
  } else if ("hcl" == key) {
    return regex_match(value, regex("#[0-9a-f]{6}"));
  } else if ("ecl" == key) {
    return regex_match(value, regex("amb|blu|brn|gry|grn|hzl|oth"));
  } else if ("pid" == key) {
    return regex_match(value, regex("[0-9]{9}"));
  } else if ("cid" == key)
    return true;
  return false;
}

long long solve(vector<string> &lines) {
  vector<vector<string>> data = readInput<string>(lines);
  long long result = 0;

  for (auto item : data) {
    set<string> idtf;
    for (string str : item) {
      string key = str.substr(0, 3), value = str.substr(4, str.size() - 4);
      if (checkValue(key, value)) {
        idtf.insert(key);
      }
    }
    result += check(idtf);
  }

  return result;
}