import std/[algorithm, heapqueue, sequtils, sugar, strutils, os, deques]

var isInput*: bool = false

proc load*() : string =
  doAssert 1 == paramCount()
  isInput = paramStr(1).contains("input")
  let file: File = open(paramStr(1))
  result = file.readAll()
  file.close()

proc toMatrix*(input: seq[string]) : seq[seq[char]] = input.map(line => line.mapIt(char it))

proc toInts*(str: string): seq[int] =
  var cur: string
  for c in str:
    if c.isDigit() or c == '-':
      cur &= c
    elif 0 < cur.len:
      result.add parseInt cur
      cur = ""
  if 0 < cur.len:
    result.add parseInt cur

# proc preCalc*[T](neighbours: (int) -> T): (int) -> T =
#   let adj {.global} = (0..<V).mapIt(neighbours(it))
#   return (proc(v: int): T = adj[v])

proc removeDist(neighbours: (int) -> seq[(int, int)]): (int) -> seq[int] = (proc(v: int): seq[int] = neighbours(v).mapIt(it[0]))

proc injectDist(neighbours: (int) -> seq[int]): (int) -> seq[(int, int)] = (proc(v: int): seq[(int, int)] = neighbours(v).mapIt (it, 1))

proc dijkstra*(neighbours: (int) -> seq[(int, int)], V, start: int): seq[int] =
  result = newSeqWith[int](V, high(int))
  var pq = [(0, start)].toHeapQueue

  while 0 < pq.len():
    let (d, v) = pq.pop()
    if result[v] <= d: continue
    result[v] = d
    for (id, distance) in neighbours(v):
      pq.push (d + distance, id)

proc dijkstra*(neighbours: (int) -> seq[(int, int)], V, start: int, ends: seq[int]): (int, int) =
  var dists = newSeqWith[int](V, high(int))
  var pq = [(0, start)].toHeapQueue

  while 0 < pq.len():
    let (d, v) = pq.pop()
    if v in ends: return (v, d)
    if dists[v] <= d: continue
    dists[v] = d
    for (id, distance) in neighbours(v):
      pq.push (d + distance, id)
  return (-1, high(int))

proc bfs*(neighbours: (int) -> seq[int], V, start: int): seq[int] = dijkstra(injectDist neighbours, V, start)

proc bfs*(neighbours: (int) -> seq[int], V, start: int, ends: seq[int]): (int, int) = dijkstra(injectDist neighbours, V, start, ends)

proc topologicalSort*(neighbours: (int) -> seq[int], V: int): seq[int] =
  var visited = newSeqWith[bool](V, false)

  for v in 0..<V:
    if not visited[v]:
      var stack = toDeque [(v, neighbours(v))]

      while 0 < stack.len:
        let (v, gen) = stack.popLast()
        visited[v] = true

        var breaked: bool = false
        for neighbour in gen:
          if not visited[neighbour]:
            stack.addLast((v, gen))
            stack.addLast((neighbour, neighbours(neighbour)))
            breaked = true
        if not breaked:
          result.add(v)
  result.reverse()

proc topologicalSort*(neighbours: (int) -> seq[(int, int)], V: int): seq[int] = topologicalSort(removeDist neighbours, V)

type Set* = object
  ## A Set of numbers
  # # for i in -2..5 -> 7..8 -> 1..7:
  # #   echo i
  # # echo 1..4 -> 3..9
  ranges: seq[HSlice[int, int]]

proc insert*(s: var Set, r: HSlice[int, int]) =
  var pos = s.ranges.lowerBound(r.a, (a, b) => cmp(a.a, b))
  s.ranges.insert(r, pos)

  while pos + 1 < s.ranges.len and s.ranges[pos].b >= s.ranges[pos + 1].a:
    s.ranges[pos] = s.ranges[pos].a..max(s.ranges[pos].b, s.ranges[pos + 1].b)
    s.ranges.delete(pos + 1)

  while 0 < pos and s.ranges[pos - 1].b >= s.ranges[pos].a:
    s.ranges[pos - 1] = s.ranges[pos - 1].a..max(s.ranges[pos - 1].b, s.ranges[pos].b)
    s.ranges.delete(pos)
    dec pos

proc `->`*(s: Set, a: HSlice[int, int]): Set =
  result = s
  result.insert a

proc `->`*(a, b: HSlice[int, int]): Set = result -> a -> b

proc `->`*(a: HSlice[int, int], s: Set): Set = s -> a

proc `$`*(s: Set): string = $s.ranges

iterator items*(s: Set): int =
  for r in s.ranges:
    for i in r:
      yield i

proc realMod*(a, n: int): int = (a mod n + n) mod n

# proc `[]`*[T](grid: seq[seq[T]], pos: (int, int)): T = grid[pos[1]][pos[0]]

# proc `[]=`*[T](grid: var seq[seq[T]], pos: (int, int), item: T) = grid[pos[1]][pos[0]] = item