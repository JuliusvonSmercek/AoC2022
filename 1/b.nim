import strutils, sequtils, algorithm, utils

var max: seq[int]
for values in load().split("\n\n"):
  max.add values.split("\n").mapIt(parseInt it).foldl(a + b)
sort(max)
echo max[^1] + max[^2] + max[^3]