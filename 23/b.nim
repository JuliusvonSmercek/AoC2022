import utils, strutils, sequtils, sugar

var grid: seq[seq[bool]]
for line in load().splitLines:
  grid.add line.mapIt(it == '#')

proc increaseGrid(grid: seq[seq[bool]], offset: int = 1): seq[seq[bool]] =
  let elves = collect(newSeq):
    for row, line in grid:
      for col, isElve in line:
        if isElve:
          (col, row)

  var lt = (elves.mapIt(it[0]).min(), elves.mapIt(it[1]).min())
  var br = (elves.mapIt(it[0]).max(), elves.mapIt(it[1]).max())

  result = newSeqWith(br[1] - lt[1] + 2 * offset + 1, newSeqWith(br[0] - lt[0] + 2 * offset + 1, false))
  for (col, row) in elves:
    result[row - lt[1] + offset][col - lt[0] + offset] = true

proc check(grid: seq[seq[bool]], items: seq[(int, int)]): bool =
  for (col, row) in items:
    if grid[row][col]:
      return false
  return true

proc north(col, row: int): auto = @[(col - 1, row - 1), (col, row - 1), (col + 1, row - 1)]
proc south(col, row: int): auto = @[(col - 1, row + 1), (col, row + 1), (col + 1, row + 1)]
proc west(col, row: int): auto = @[(col - 1, row - 1), (col - 1, row), (col - 1, row + 1)]
proc east(col, row: int): auto = @[(col + 1, row - 1), (col + 1, row), (col + 1, row + 1)]
proc all(col, row: int): auto = north(col, row) & south(col, row) & west(col, row) & east(col, row)

var change = true
var k = 0
while change:
  change = false

  grid = increaseGrid grid
  let elves = collect(newSeq):
    for row, line in grid:
      for col, isElve in line:
        if isElve:
          (col, row)

  var tempGrid: seq[seq[int]] = newSeqWith(grid.len, newSeqWith(grid[0].len, 0))
  for (col, row) in elves:
    if not grid.check all(col, row):
      let items = @[north(col, row), south(col, row), west(col, row), east(col, row)]
      for j in 0..<4:
        let dir = items[(j + k) mod 4]
        if grid.check dir:
          let (c, r) = dir[1]
          inc tempGrid[r][c]
          break

  var newGrid: seq[seq[bool]] = newSeqWith(grid.len, newSeqWith(grid[0].len, false))
  for (col, row) in elves:
    var pos: (int, int) = (col, row)
    if not grid.check all(col, row):
      let items = @[north(col, row), south(col, row), west(col, row), east(col, row)]
      for j in 0..<4:
        let dir = items[(j + k) mod 4]
        if grid.check dir:
          let (c, r) = dir[1]
          if tempGrid[r][c] == 1: pos = (c, r)
          break
    newGrid[pos[1]][pos[0]] = true

  change = (grid != newGrid)
  grid = newGrid
  inc k
echo k