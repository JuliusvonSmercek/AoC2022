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

var cache = newSeq[Table[int64, int]](N * N * 31)
proc bf(node: (int, int), visited: var seq[bool], notOpenedSince: seq[int], steps: int): int =
  if steps <= 0:
    return 0

  let (a, b) = node

  let gt = seqToInt visited
  let val1 = if a < b:
      31 * N * a + 31 * b + steps
    else:
      31 * N * b + 31 * a + steps

  if cache[val1].contains(gt):
    return cache[val1][gt]

  if a != b:
    if 0 < rate[a] and 1 < steps and not visited[a]:
      if 0 < rate[b] and 1 < steps and not visited[b]:
        visited[a] = true
        visited[b] = true
        result = bf((a, b), visited, @[], steps - 1) + (steps - 1) * (rate[a] + rate[b])
        visited[a] = false
        visited[b] = false
  if 0 < rate[a] and 1 < steps and not visited[a]:
    for target in adj[b]:
      if target notin notOpenedSince:
        visited[a] = true
        result = max(result, bf((a, target), visited, @[b], steps - 1) + (steps - 1) * rate[a])
        visited[a] = false
  if 0 < rate[b] and 1 < steps and not visited[b]:
    for target in adj[a]:
      if target notin notOpenedSince:
        visited[b] = true
        result = max(result, bf((target, b), visited, @[a], steps - 1) + (steps - 1) * rate[b])
        visited[b] = false
  for targetA in adj[a]:
    for targetB in adj[b]:
      if targetA notin notOpenedSince and targetB notin notOpenedSince:
        result = max(result, bf((targetA, targetB), visited, notOpenedSince & targetA & targetB, steps - 1))
  cache[val1][gt] = result

var visited = newSeqWith[bool](N, false)
echo bf((start, start), visited, @[], 26)