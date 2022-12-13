import strutils, utils

var result = 0
for line in load().splitLines:
  let a = int(line[0]) - int('A')
  let x = int(line[2]) - int('X')
  result += 3 * x + 1 + (2 + x + a) mod 3
echo result