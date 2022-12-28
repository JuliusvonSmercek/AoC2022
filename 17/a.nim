import utils, sequtils

let pattern = load().mapIt(if it == '<': -1 else: 1)

proc rockDash(x, y: int): auto = @[(x, y), (x + 1, y), (x + 2, y), (x + 3, y)]
proc rockPlus(x, y: int): auto = @[(x + 1, y), (x, y + 1), (x + 1, y + 1), (x + 2, y + 1), (x + 1, y + 2)]
proc rockMirL(x, y: int): auto = @[(x + 2, y + 2), (x + 2, y + 1), (x, y), (x + 1, y), (x + 2, y)]
proc rockVert(x, y: int): auto = @[(x, y), (x, y + 1), (x, y + 2), (x, y + 3)]
proc rockQuad(x, y: int): auto = @[(x, y), (x + 1, y), (x, y + 1), (x + 1, y + 1)]
let rocks = @[rockDash, rockPlus, rockMirL, rockVert, rockQuad]

const steps = 2022
var matrix: array[0..(3 * steps - 1), array[0..6, bool]]

template ix(): int = it[0]
template iy(): int = it[1]

proc shift(rock: seq[(int, int)]): seq[(int, int)] =
  var patternPos {.global} = 0
  let shiftVal = pattern[patternPos mod pattern.len]
  result = rock.mapIt (ix + shiftVal, iy)
  inc patternPos
  if result.anyIt(ix < 0 or 7 <= ix or matrix[iy][ix]):
    return rock

proc collidesFloorRock(rock: seq[(int, int)]): bool =
  rock.anyIt(iy < 0 or matrix[iy][ix])

proc down(rock: seq[(int, int)]): seq[(int, int)] =
  rock.mapIt((ix, iy - 1))

var yOffset = 0
for i in 0..<steps:
  var current = shift rocks[i mod 5](2, yOffset + 3)
  var temp = down(current)
  while not collidesFloorRock(temp):
    current = shift(temp)
    temp = down(current)

  for (x, y) in current:
    matrix[y][x] = true
    yOffset = max(yOffset, y + 1)

echo yOffset