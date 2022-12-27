import utils, strutils, tables, sequtils, sugar

var nameToId: Table[string, int]
proc toHash(valve: string): int =
  var counter {.global} = 0
  if valve notin nameToId:
    nameToId[valve] = counter
    inc counter
  return nameToId[valve]

let lines = load().splitLines
let N = lines.len
var adj = newSeq[seq[int]](N)
var rate = newSeq[int](N)
for line in lines:
  let
    items = line.split(" ")
    id = toHash items[1]
  rate[id] = items[4].toInts()[0]
  for target in items[9..<items.len].map(valve => toHash(valve.replace(",", ""))):
    adj[id].add(target)

let start = nameToId["AA"]

proc seqToInt(list: seq[bool]): int64 =
  for item in list:
    result = result shl 1
    if item: inc result

var cache = newSeq[Table[int64, int]](N * 31)
proc bf(node: int, visited: var seq[bool], notOpenedSince: seq[int], steps: int): int =
  if steps <= 0:
    return 0
  let gt = seqToInt visited
  let val1 = 31 * node + steps
  if cache[val1].contains(gt):
    return cache[val1][gt]
  if 0 < rate[node] and 1 < steps and not visited[node]:
    visited[node] = true
    result = bf(node, visited, @[], steps - 1) + (steps - 1) * rate[node]
    visited[node] = false
  for target in adj[node]:
    if target notin notOpenedSince:
      result = max(result, bf(target, visited, notOpenedSince & node, steps - 1))
  cache[val1][gt] = result

var visited = newSeqWith[bool](N, false)
echo bf(start, visited, @[], 30)