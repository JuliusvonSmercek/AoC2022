#include "utils.h"

class Monkey {
 public:
  queue<ll> items;
  const function<ll(ll)> operation;
  const ll conditionValue, monkeyTrue, monkeyFalse;

  Monkey(vector<ll> itemsVec, function<ll(ll)> operation, ll conditionValue,
         ll monkeyTrue, ll monkeyFalse)
      : operation(operation),
        conditionValue(conditionValue),
        monkeyTrue(monkeyTrue),
        monkeyFalse(monkeyFalse) {
    for (ll item : itemsVec) items.push(item);
  }
};

long long solve(vector<string> &lines) {
  vector<Monkey> monkeys;
  if (isSample) {
    monkeys = vector<Monkey>{
        {{79, 98}, [](ll old) { return old * 19; }, 23, 2, 3},
        {{54, 65, 75, 74}, [](ll old) { return old + 6; }, 19, 2, 0},
        {{79, 60, 97}, [](ll old) { return old * old; }, 13, 1, 3},
        {{74}, [](ll old) { return old + 3; }, 17, 0, 1}};
  } else {
    monkeys = vector<Monkey>{
        {{75, 63}, [](ll old) { return old * 3; }, 11, 7, 2},
        {{65, 79, 98, 77, 56, 54, 83, 94}, [](ll old) { return old + 3; }, 2,2, 0},
        {{66}, [](ll old) { return old + 5; }, 5, 7, 5},
        {{51, 89, 90}, [](ll old) { return old * 19; }, 7, 6, 4},
        {{75, 94, 66, 90, 77, 82, 61}, [](ll old) { return old + 1; }, 17, 6,1},
        {{53, 76, 59, 92, 95}, [](ll old) { return old + 2; }, 19, 4, 3},
        {{81, 61, 75, 89, 70, 92}, [](ll old) { return old * old; }, 3, 0,1},
        {{81, 86, 62, 87}, [](ll old) { return old + 8; }, 13, 3, 5}};
  }

  vector<int> counter(monkeys.size(), 0);
  for (int i = 0; i < 20; ++i) {
    for (int pos = 0; Monkey &monkey : monkeys) {
      while (!monkey.items.empty()) {
        ++counter[pos];
        ll item = monkey.items.front();
        monkey.items.pop();
        item = monkey.operation(item) / 3;
        if (0 == item % monkey.conditionValue)
          monkeys[monkey.monkeyTrue].items.push(item);
        else
          monkeys[monkey.monkeyFalse].items.push(item);
      }
      ++pos;
    }
  }
  sort(counter.rbegin(), counter.rend());
  return counter[0] * counter[1];
}