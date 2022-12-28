import std/[algorithm, heapqueue, sequtils, sugar, strutils, os]

var isInput*: bool = false

proc load*() : string =
  doAssert 1 == paramCount()
  isInput = paramStr(1).contains("input")
  let file: File = open(paramStr(1))
  result = file.readAll()
  file.close()

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

proc dijkstra*(neighbours: (int) -> seq[(int, int)], N, start: int): seq[int] =
  result = newSeqWith[int](N, high(int))
  var pq = [(0, start)].toHeapQueue

  while 0 < pq.len():
    let (d, v) = pq.pop()
    if result[v] <= d: continue
    result[v] = d
    for (id, distance) in neighbours(v):
      pq.push (d + distance, id)

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