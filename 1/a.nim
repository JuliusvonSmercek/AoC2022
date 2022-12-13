import strutils, sequtils, utils

var max = 0
for values in load().split("\n\n"):
  max = max(max, values.split("\n").mapIt(parseInt it).foldl(a + b))
echo max