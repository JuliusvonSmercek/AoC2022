import utils, strutils, sequtils

proc splitPath(rawPath: string): seq[string] =
  var cur = ""
  for c in rawPath:
    if isDigit c:
      cur &= c
    else:
      if 0 < cur.len:
        result.add(cur)
      cur = ""
      result.add("" & c)
  if 0 < cur.len:
    result.add(cur)

var input = load().split("\n\n")
var map = input[0]
var rawPath = input[1]

type Item = enum Free, Wall, Unknown
var grid: seq[seq[Item]]

var maxLen = map.split("\n").mapIt(it.len).foldl(max(a, b))
for line in map.splitLines:
  var newItem = newSeqWith(maxLen, Unknown)
  for index, c in line:
    if c == '.':
      newItem[index] = Free
    elif c == '#':
      newItem[index] = Wall
  grid.add newItem

var startX, startY, orientation = 0
for index, item in grid[0]:
  if item == Free:
    startX = index
    break

for item in splitPath(rawPath):
  if item == "R": orientation = (orientation + 1) mod 4
  elif item == "L": orientation = (orientation + 3) mod 4
  else:
    let value = parseInt item
    if orientation == 0 or orientation == 2:
      let shiftVal = (if orientation == 0: 1 else: grid[startY].len - 1)
      for i in 0..<value:
        let oldPos = startX
        startX = (startX + shiftVal) mod grid[startY].len
        while grid[startY][startX] == Unknown:
          startX = (startX + shiftVal) mod grid[startY].len
        if grid[startY][startX] == Wall:
          startX = oldPos
          break
    elif orientation == 1 or orientation == 3:
      let shiftVal = (if orientation == 1: 1 else: grid.len - 1)
      for i in 0..<value:
        let oldPos = startY
        startY = (startY + shiftVal) mod grid.len
        while grid[startY][startX] == Unknown:
          startY = (startY + shiftVal) mod grid.len
        if grid[startY][startX] == Wall:
          startY = oldPos
          break

echo 1000 * (startY + 1) + 4 * (startX + 1) + orientation