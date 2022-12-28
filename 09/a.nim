import strutils, sets

let
  file: File = open("input.txt")
  input: string = file.readAll()
  lines: seq[string] = input.splitLines

var visited: HashSet[(int, int)]

var
  H = (0, 0)
  T = (0, 0)

template x(pair: (int, int)): int = pair[0]

template y(pair: (int, int)): int = pair[1]

for line in lines:
  let
    items: seq[string] = line.splitWhitespace()
    letter: char = items[0][0]
    number: int = parseInt items[1]

  for i in 0..<number:
    let
      dx = H.x - T.x
      dy = H.y - T.y

    case letter:
      of 'R':
        if 1 == dx: T = H
        inc H.x
      of 'L':
        if -1 == dx: T = H
        dec H.x
      of 'U':
        if 1 == dy: T = H
        inc H.y
      of 'D':
        if -1 == dy: T = H
        dec H.y
      else: discard
    visited.incl(T)

echo visited.len