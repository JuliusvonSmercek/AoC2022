import sequtils, sugar

# feature wish:
var list: seq[(int, int)] # = ...
discard list.map(it => (it[0] + 1, it[1]))

# should be:
discard list.map((x, y) => (x + 1, y))

# workaround:
template x(): int = it[0]
template y(): int = it[1]
discard list.mapIt (x + 1, y)