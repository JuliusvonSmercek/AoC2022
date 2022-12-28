import utils, sequtils

let pattern = load().mapIt(if it == '<': -1 else: 1)

proc rockDash(x, y: int): auto = @[(x, y), (x + 1, y), (x + 2, y), (x + 3, y)]
proc rockPlus(x, y: int): auto = @[(x + 1, y), (x, y + 1), (x + 1, y + 1), (x + 2, y + 1), (x + 1, y + 2)]
proc rockMirL(x, y: int): auto = @[(x + 2, y + 2), (x + 2, y + 1), (x, y), (x + 1, y), (x + 2, y)]
proc rockVert(x, y: int): auto = @[(x, y), (x, y + 1), (x, y + 2), (x, y + 3)]
proc rockQuad(x, y: int): auto = @[(x, y), (x + 1, y), (x, y + 1), (x + 1, y + 1)]
let rocks = @[rockDash, rockPlus, rockMirL, rockVert, rockQuad]

type GameField = tuple # why is here not 'ref tuple' possible?
  matrix: seq[array[0..6, bool]]
  patternPos: int

template ix(): int = it[0]
template iy(): int = it[1]

proc shift(field: var GameField, rock: seq[(int, int)]): seq[(int, int)] =
  let shiftVal = pattern[field.patternPos mod pattern.len]
  result = rock.mapIt (ix + shiftVal, iy)
  inc field.patternPos
  if result.anyIt(ix < 0 or 7 <= ix or field.matrix[iy][ix]):
    return rock

proc collidesFloorRock(field: GameField, rock: seq[(int, int)]): bool =
  rock.anyIt(iy < 0 or field.matrix[iy][ix])

proc down(rock: seq[(int, int)]): seq[(int, int)] =
  rock.mapIt((ix, iy - 1))

const maxSteps = 10000 # huge number
var
  field: GameField
  yOffset, yDiff = 0
  yOffsetTo: seq[int]
  cache: seq[(int, int)]

for i in 0..<maxSteps:
  if field.matrix.len - yOffset < 10:
    field.matrix = field.matrix.concat newSeq[array[0..6, bool]](1000)
  var current = field.shift rocks[i mod 5](2, yOffset + 3)
  var temp = down(current)
  while not field.collidesFloorRock(temp):
    current = field.shift(temp)
    temp = down(current)

  for (x, y) in current:
    field.matrix[y][x] = true
    yOffset = max(yOffset, y + 1)

  cache.add (current[0][0], current[0][1] - yDiff)
  yDiff = current[0][1]
  yOffsetTo.add yOffset

var startCycling = maxSteps
var cycleInterval = -1
for k in 1..<cache.len:
  for i in countdown(cache.len - 1 - k, 0):
    if cache[i + k] != cache[i]:
      if i + k < startCycling:
        startCycling = i
        cycleInterval = k
      break

let finalHeight = 1000000000000
let intervals = finalHeight div cycleInterval
var rest = finalHeight - cycleInterval * intervals - 1
while rest < startCycling:
  rest += cycleInterval
echo yOffsetTo[rest] + intervals * (yOffsetTo[^1] - yOffsetTo[^(cycleInterval + 1)])