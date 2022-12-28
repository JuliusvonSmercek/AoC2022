import utils, strutils

proc parseSNAFU(str: string): int =
  var base = 1
  for i in countdown(str.len - 1, 0):
    let temp = case str[i]:
        of '=': -2
        of '-': -1
        of '0': 0
        of '1': 1
        of '2': 2
        else: quit(0)
    result += base * temp
    base *= 5

proc toSNAFU(value: int): string =
  if 0 == value: return "0"
  var base = 1
  var lastVal = (value + (base div 2)) div base
  while 0 != lastVal:
    let temp = case lastVal mod 5:
        of 4: "="
        of 3: "-"
        of 0: "0"
        of 1: "1"
        else: "2"
    lastVal = (value + (base div 2)) div base
    result = temp & result
    base *= 5

var result = 0
for line in load().splitLines:
  result += parseSNAFU line
echo toSNAFU result