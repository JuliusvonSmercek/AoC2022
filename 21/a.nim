import utils, strutils, tables, sugar

type
  CalculationType = enum Equation, Value

  Calculation = object
    case kind: CalculationType
      of Equation:
        operation: string
        id1, id2: int
      of Value:
        value: int

var nameId: Table[string, int]
var data: seq[string]
for line in load().splitLines:
  let items = line.split(": ")
  nameId[items[0]] = data.len
  data.add items[1]

var calculations: seq[Calculation]
for item in data:
  let calc = item.split(" ")
  calculations.add if 1 < calc.len:
    Calculation(kind: Equation, id1: nameId[calc[0]], operation: calc[1], id2: nameId[calc[2]])
  else:
    Calculation(kind: Value, value: parseInt item)

var adj = newSeq[seq[int]](calculations.len)
for id, calculation in calculations:
  if calculation.kind == Equation:
    adj[calculation.id1].add id
    adj[calculation.id2].add id

for item in topologicalSort(v => adj[v], calculations.len):
  let calc = calculations[item]
  if calc.kind == Equation:
    let
      v1 = calculations[calc.id1].value
      v2 = calculations[calc.id2].value
      res = case calc.operation:
        of "+": v1 + v2
        of "-": v1 - v2
        of "*": v1 * v2
        else: v1 div v2
    calculations[item] = Calculation(kind: Value, value: res)

echo calculations[nameId["root"]].value