import utils, strutils, tables, sugar

type
  CalculationType = enum Equation, Value, Variable

  Calculation = object
    case kind: CalculationType
      of Equation:
        operation: string
        id1, id2: int
      of Value:
        value: int
      of Variable:
        discard

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

calculations[nameId["humn"]] = Calculation(kind: Variable)

for item in topologicalSort(v => adj[v], calculations.len):
  let calc = calculations[item]
  if calc.kind == Equation and calculations[calc.id1].kind == Value and calculations[calc.id2].kind == Value:
    let
      v1 = calculations[calc.id1].value
      v2 = calculations[calc.id2].value
      res = case calc.operation:
        of "+": v1 + v2
        of "-": v1 - v2
        of "*": v1 * v2
        else: v1 div v2
    calculations[item] = Calculation(kind: Value, value: res)

proc solve(eq: Calculation, should_be: int): int =
  doAssert eq.kind != Value
  if eq.kind == Variable: return should_be
  let c1 = calculations[eq.id1]
  let c2 = calculations[eq.id2]
  return if c2.kind == Value:
    case eq.operation:
      of "+": solve(c1, should_be - c2.value)
      of "*": solve(c1, should_be div c2.value)
      of "-": solve(c1, should_be + c2.value)
      else: solve(c1, should_be * c2.value)
  else:
    case eq.operation:
      of "+": solve(c2, should_be - c1.value)
      of "*": solve(c2, should_be div c1.value)
      of "-": solve(c2, c1.value - should_be)
      else: solve(c2, c1.value div should_be)

let
  root = calculations[nameId["root"]]
  c1 = calculations[root.id1]
  c2 = calculations[root.id2]
echo if c1.kind == Value: solve(c2, c1.value) else: solve(c1, c2.value)