import utils, strutils, algorithm

var sensors: seq[((int, int), (int, int))]
for line in load().splitLines:
  let ints: seq[int] = line.toInts()
  sensors.add(((ints[0], ints[1]), (ints[2], ints[3])))

type Range = object
  startPos, endPos: int

proc `<`(a, b: Range): bool = a.startPos < b.startPos

let maxVal = if isInput: 4000000 else: 20

for py in 0..maxVal:
  var notBeacon: seq[Range]
  for (a, b) in sensors:
    let (x, y) = a
    let (bx, by) = b
    let manhatten = abs(bx - x) + abs(by - y)
    let intervall = manhatten - abs(py - y)
    if 0 <= intervall:
      notBeacon.add Range(startPos: x - intervall, endPos: x + intervall)

  sort(notBeacon)

  var lastPos = 0
  for beacon in notBeacon:
    if lastPos + 1 >= beacon.startPos:
      lastPos = max(lastPos, beacon.endPos)
    else:
      doAssert lastPos + 1 == beacon.startPos - 1
      echo (lastPos + 1) * 4000000 + py
      quit(0)
    if maxval < lastPos:
      break