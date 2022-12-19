import utils, strutils, sequtils

var data: seq[(int, int, int)]
for line in load().splitLines:
  let ints = line.toInts()
  data.add (ints[0], ints[1], ints[2])

var highxyz: (int, int, int) = (low int, low int, low int)
for (x, y, z) in data:
  let (hx, hy, hz) = highxyz
  highxyz = (max(hx, x), max(hy, y), max(hz, z))

var cubes: seq[seq[seq[bool]]] = newSeqWith[seq[seq[int]]](highxyz[0] + 1, newSeqWith[seq[int]](highxyz[1] + 1, newSeqWith[int](highxyz[2] + 1, false)))
for (x, y, z) in data:
  cubes[x][y][z] = true

var result = 0
for (x, y, z) in data:
  if cubes[x][y][z]:
    if x == highxyz[0] or not cubes[x + 1][y][z]: inc result
    if y == highxyz[1] or not cubes[x][y + 1][z]: inc result
    if z == highxyz[2] or not cubes[x][y][z + 1]: inc result
    if x == 0 or not cubes[x - 1][y][z]: inc result
    if y == 0 or not cubes[x][y - 1][z]: inc result
    if z == 0 or not cubes[x][y][z - 1]: inc result
echo result