import utils, strutils, sets

var sensors: seq[((int, int), (int, int))]
for line in load().splitLines:
  let ints: seq[int] = line.toInts()
  sensors.add(((ints[0], ints[1]), (ints[2], ints[3])))

let py = if isInput: 2000000 else: 10

var notBeacon: HashSet[int]
for (a, b) in sensors:
  let (x, y) = a
  let (bx, by) = b
  let manhatten = abs(bx - x) + abs(by - y)
  let intervall = manhatten - abs(py - y)
  if 0 <= intervall:
    for i in (x - intervall)..(x + intervall):
      notBeacon.incl i

for (a, b) in sensors:
  if b[1] == py:
    notBeacon.excl b[0]

echo notBeacon.len