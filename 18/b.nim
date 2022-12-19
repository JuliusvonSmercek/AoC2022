import utils, strutils, sequtils

var data: seq[(int, int, int)]
for line in load().splitLines:
  let ints = line.toInts()
  data.add (ints[0], ints[1], ints[2])

var highxyz: (int, int, int) = (low int, low int, low int)
for (x, y, z) in data:
  let (hx, hy, hz) = highxyz
  highxyz = (max(hx, x), max(hy, y), max(hz, z))

var cubes: seq[seq[seq[bool]]] = newSeqWith[seq[seq[int]]](highxyz[0] + 2, newSeqWith[seq[int]](highxyz[1] + 2, newSeqWith[int](highxyz[2] + 2, false)))
for (x, y, z) in data:
  cubes[x][y][z] = true

let allHigh = max(cubes.len, max(cubes[0].len, cubes[0][0].len)) + 1

proc zip(x, y, z: int): int = allHigh * allHigh * x + allHigh * y + z

proc unzip(value: int): (int, int, int) = ((value div (allHigh * allHigh)) mod allHigh, (value div allHigh) mod allHigh, value mod allHigh)

proc neighbours(vertex: int): seq[(int, int)] =
  let (x, y, z) = unzip(vertex)

  for (px, py, pz) in @[(x + 1, y, z), (x - 1, y, z), (x, y + 1, z), (x, y - 1, z), (x, y, z + 1), (x, y, z - 1)]:
    if 0 <= px and px < cubes.len and 0 <= py and py < cubes[0].len and 0 <= pz and pz < cubes[0][0].len:
      if not cubes[px][py][pz]:
        result.add (zip(px, py, pz), 1)

var N = zip(cubes.len, cubes[0].len, cubes[0][0].len)
let dist = dijkstra(neighbours, N, zip(0, 0, 0))

var result = 0
for (x, y, z) in data:
  if cubes[x][y][z]:
    if x == highxyz[0] or (not cubes[x + 1][y][z] and dist[zip(x + 1, y, z)] != high(int)): inc result
    if y == highxyz[1] or (not cubes[x][y + 1][z] and dist[zip(x, y + 1, z)] != high(int)): inc result
    if z == highxyz[2] or (not cubes[x][y][z + 1] and dist[zip(x, y, z + 1)] != high(int)): inc result
    if x == 0 or (not cubes[x - 1][y][z] and dist[zip(x - 1, y, z)] != high(int)): inc result
    if y == 0 or (not cubes[x][y - 1][z] and dist[zip(x, y - 1, z)] != high(int)): inc result
    if z == 0 or (not cubes[x][y][z - 1] and dist[zip(x, y, z - 1)] != high(int)): inc result
echo result