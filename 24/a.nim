import utils, strutils, sequtils, math, sugar

let
  lines = load().splitLines
  X = lines[0].len
  Y = lines.len
  timeSteps = lcm(X, Y)
  V = X * Y * timeSteps
  startPos = (lines[0].find("."), 0)
  endPos = (lines[Y - 1].find("."), Y - 1)

  blizzards = collect(newSeq):
    for y, line in lines.toMatrix:
      for x, c in line:
        if c in @['^', '>', 'v', '<']: (c, x, y)

# x, y, time
type Pos = (int, int, int) # distinct

proc zip*(pos: Pos): int = pos[0] + pos[1] * X + pos[2] * X * Y

proc unzip*(value: int): Pos = (value mod X, (value div X) mod Y, value div (X * Y))

proc simulate(blizzard: (char, int, int), time: int): (int, int) =
  let (direction, x, y) = blizzard
  var res = case direction:
    of '>': (x + time, y)
    of '<': (x - time, y)
    of 'v': (x, y + time)
    of '^': (x, y - time)
    else: quit(0)
  res[0] = realMod(res[0] - 1, X - 2) + 1
  res[1] = realMod(res[1] - 1, Y - 2) + 1
  return res

let blizzardsAt = (0..<timeSteps).mapIt(blizzards.map(blizzard => blizzard.simulate(it)))
proc neighbours(vertex: int): seq[int] =
  let (x, y, time) = unzip(vertex)
  let newTime = (time + 1) mod timeSteps
  return collect(newSeq):
    for (x, y) in @[(x, y), (x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]:
      if (x, y) == startPos or (x, y) == endPos or (1 <= x and x < X - 1 and 1 <= y and y < Y - 1):
        if (x, y) notin blizzardsAt[newTime]:
          zip (x, y, newTime)

let ends = (0..<timeSteps).mapIt(zip (endPos[0], endPos[1], it))
echo bfs(neighbours, V, zip (startPos[0], startPos[1], 0), ends)[1]