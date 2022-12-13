import strutils, algorithm

type
  ItemKind = enum List, Value

  Item = object
    case kind: ItemKind
      of List:
        list: seq[Item]
      of Value:
        value: int

  TokenIter = object
    data: string
    pos: int

  Order = enum Right, NotRight, Undef

proc mkList(lst: Item): Item = Item(kind: List, list: @[lst])

proc mkValue(val: int): Item = Item(kind: Value, value: val)

proc nextInt(iter: var TokenIter) : int =
  while isDigit iter.data[iter.pos]:
    result = 10 * result + parseInt $iter.data[iter.pos]
    inc iter.pos

proc take(iter: var TokenIter, c: char) : bool =
  result = (c == iter.data[iter.pos])
  if result:
    inc iter.pos

proc toItem(iter: var TokenIter): Item =
  if iter.take('['):
    var items: seq[Item]
    if not iter.take(']'):
      items.add(toItem(iter))
      while iter.take(','):
        items.add(toItem(iter))
      doAssert iter.take(']')
    result = Item(kind: List, list: items)
  else:
    result = Item(kind: Value, value: iter.nextInt)

proc toItem(data: string): Item =
  var tk = TokenIter(data: data, pos: 0)
  return tk.toItem()

proc `$`(item : Item): string =
  case item.kind:
    of List:
      result = "["
      for index, it in item.list:
        if 0 != index:
          result &= ", "
        result &= $it
      return result & "]"
    of Value: return $item.value

proc cmpr(left, right: int): Order =
  if left < right: Right
  elif left > right: NotRight
  else: Undef

proc `<=>`(left, right: Item): Order =
  if left.kind == Value and right.kind == Value:
    return cmpr(left.value, right.value)
  elif left.kind == List and right.kind == List:
    for i in 0..<min(left.list.len, right.list.len):
      if (left.list[i] <=> right.list[i]) != Undef:
        return left.list[i] <=> right.list[i]
    return cmpr(left.list.len, right.list.len)
  elif left.kind == List and right.kind == Value:
    return left <=> mkList(right)
  else:
    return mkList(left) <=> right

proc `<`(left, right: Item): bool = (left <=> right) == Right

proc `==`(left, right: Item): bool = (left <=> right) == Undef

let
  file: File = open("input.txt")
  input: string = file.readAll()
  items: seq[string] = input.split("\n\n")

  it2 = mkList mkList mkValue 2
  it6 = mkList mkList mkValue 6

var its = @[it2, it6]
for temp in items:
  let item = temp.split("\n")
  its.add toItem(item[0])
  its.add toItem(item[1])

sort(its)

var mul = 1
for index, it in its:
  if it == it2 or it == it6:
    mul *= index + 1
echo mul