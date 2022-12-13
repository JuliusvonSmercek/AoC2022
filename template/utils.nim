import os

proc load*() : string =
  doAssert 1 == paramCount()
  let file: File = open(paramStr(1))
  result = file.readAll()
  file.close()