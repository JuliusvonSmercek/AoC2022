import strutils, os

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