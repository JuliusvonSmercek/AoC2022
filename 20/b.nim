import utils, strutils, sequtils

var numbers: seq[(int, int)]
var i1 = 0
for line in load().splitLines:
  numbers.add (811589153 * parseInt line, i1)
  inc i1

for i in 0..<10:
  for pos in 0..<numbers.len:
    let index = numbers.mapIt(it[1]).find(pos)
    let item = numbers[index]
    numbers.delete(index)
    numbers.insert(item, realMod(index + item[0], numbers.len))

let pos0 = numbers.mapIt(it[0]).find(0)
echo @[1000, 2000, 3000].mapit(numbers[(pos0 + it) mod numbers.len][0]).foldl(a + b)