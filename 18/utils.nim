import std/[heapqueue, sequtils, sugar, strutils, os]

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