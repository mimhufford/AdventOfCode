const input = `
RRLLRLLRULLRUUUDRDLDDLLLDDDDDUUURRRRUUDLRULURRRDRUDRUUDDRUDLLLRLDDDUDRDDRRLLLLRLRLULUURDRURRUULDRRDUDURRUURURDLURULLDUDRDLUUUUDDURRLLLUDLDLRDRRRDULLDLDULLDRLDLDURDLRRULLDDLDRLLLUDDLLRDURULLDDDDDUURURLRLRRDUURUULRLLLULLRLULLUUDRRLLDURLDDDDULUUDLUDDDULRLDURDDRUUDRRUUURLLLULURUDRULDRDUDUDRRDDULRURLLRRLRRLLDLULURDRDRULDRDRURUDLLRRDUUULDDDUURDLULDLRLLURRURLLUDURDDRUDRDLLLLDLRLDLDDRDRRDUUULLUULRRDLURLDULLDLDUUUULLLDRURLRULLULRLULUURLLRDDRULDULRLDRRURLURUDLRRRLUDLDUULULLURLDDUDDLLUDRUDRLDUDURRRRLRUUURLUDDUDURDUDDDLLRLRDDURDRUUDUDRULURLRLDRULDRRLRLDDDRDDDRLDUDRLULDLUDLRLRRRLRDULDDLRRDDLDDULDLLDU
RULLUDDUDLULRRDLLDRUDLLLDURLLLURDURLRDRRDLRDRDLLURRULUULUDUDDLLRRULLURDRLDURDLDDUURLUURLDLDLRLDRLRUULDRLRLDRLRLUDULURDULLLDRUDULDURURRRUDURDUDLRDRRURULRRLRLRRRRRRDRUDLDRULDRUDLRDLRRUDULDLRLURRRLLDRULULRUDULRLULLRLULDRUDUULLRUULDULDUDDUUULLLDRDDRRDLURUUDRRLRRRDLRRLULLLLDLRUULDLLULURUURURDRURLLDUDRRURRURRUUDDRRDDRRRRUDULULRLUULRRDDRDDLLUDLDLULLRLDRLLUULDURLDRULDDUDRUUUURRLDDUDRUURUDLLDLDLURDLULDRLLLULLLUDLLDLD
RDLDULURDLULRRDLRLLLULRUULURULLLDLLDDRLLURUUUURDRLURLLRLRLLLULRDLURDURULULDDUDDUDRLRLDLULLURRRUULUDRDURRRUDDDLUDLDLRLRRLLLRUULLLLURRDDDRRRUURULRLDRRRLRLUDDRRULDDDRUUDDRLLDULRLUDUDLDLDDDUDDLLDDRDRDUDULDRRUDRDRRDRLUURDLRDDDULLDRRRRRUDRLURDUURRDDRLUDLURRRLRDDDLRRLUULRLURDUUURRDLDDULLLRURRRUDRLUDLLDDDDDUDDRDULLUUDDURRLULLUDULUUDRLDRRRLLURLRRLLDLLLLUDRUUUDDULLRDLLDUDUDUURRUUUDRUURDRDLLDLDDULLDDRRULDLDDUUURLDLULLLRRLLRDDULLDLDLDDLDLDULURRDURURDRDRRDLR
RDRLRRUUDRLDUDLLDLUDLUUDUDLRRUUDRDDDLDDLLLRRRUDULLRRRRRURRRLUDDDLRRRRUUULDURDRULLDLRURRUULUDRURRRRLRURLRDUUDUDUDRDDURRURUDLLLLLRURUULRUURLLURDRUURLUDDDRLDDURDLDUDRURDRLRRRRUURDDRRRRURDLUUDRLDRDUULURUDDULLURRDUDLUULLDURRURLUDUUDRDDDUUDDUUUULDLDUDDLUDUUDRURLLULRUUULLRRDDUDDLULDDUUUDLUDDLDDLLRUUDRULLRRDRLLDLLRRLULLRRDDRLRDUULLLUULLDLLUDUDDLRDULUDLDLUDDRRRRDUDLUULLULDLRRDLULRLRRRULRURRDRLULDDUDLDLDULLURLLRDLURRULURDLURLUDRDRRUUDRLLUDDRLRDDUURLRRDUDLDRURDUUUDRRLLRDLDLLDRRURLUDURUULDUDLDDDDRUULLDDRLRURRDURLURRLDDRRRRLRLRDRURUDDRDLDRURLULDDL
RULRDLDDLRURDDDDDDRURLLLDDDUUULLRRDLDLURUURLUDLURRLUDUURDULDRUULDDURULDUULDDULLLUDLRULDRLDLRDDRRDLDDLLDRRUDDUDRDUULUDLLLDDLUUULDDUUULRRDULLURLULDLRLLLRLURLLRLRLDRDURRDUUDDURRULDDURRULRDRDUDLRRDRLDULULDRDURDURLLLDRDRLULRDUURRUUDURRDRLUDDRRLDLDLULRLLRRUUUDDULURRDRLLDLRRLDRLLLLRRDRRDDLDUULRLRRULURLDRLRDULUDRDLRUUDDDURUDLRLDRRUDURDDLLLUDLRLURDUDUDULRURRDLLURLLRRRUDLRRRLUDURDDDDRRDLDDLLDLRDRDDRLLLURDDRDRLRULDDRRLUURDURDLLDRRRDDURUDLDRRDRUUDDDLUDULRUUUUDRLDDD`

const keypad1 = [
  ["1", "2", "3"],
  ["4", "5", "6"],
  ["7", "8", "9"],
]
const keypad2 = [
  ["X", "X", "1", "X", "X"],
  ["X", "2", "3", "4", "X"],
  ["5", "6", "7", "8", "9"],
  ["X", "A", "B", "C", "X"],
  ["X", "X", "D", "X", "X"],
]

// Turn into  [ ['U','L','L'], ['R','R','D','D','D'], etc ]
const lines = input.trim().split("\n").map(line => line.split(''))

// Take a keypad, a starting x and y, and direction to move in, and spit out the new x and y
const move = (keypad, x, y, direction) => {
  const dx = direction == "R" ? 1 : direction == "L" ? -1 : 0
  const dy = direction == "D" ? 1 : direction == "U" ? -1 : 0
  const xCapped = Math.min(Math.max(x + dx, 0), keypad.length - 1)
  const yCapped = Math.min(Math.max(y + dy, 0), keypad.length - 1)

  return {
    x: keypad[yCapped][xCapped] === "X" ? x : xCapped,
    y: keypad[yCapped][xCapped] === "X" ? y : yCapped
  }
}

const solveOne = (keypad, steps, x, y) => {
  if (steps.length == 0) return { x, y }
  const newPos = move(keypad, x, y, steps[0])
  return solveOne(keypad, steps.slice(1), newPos.x, newPos.y)
}

const solve = (keypad, lines, x, y, acc=[]) => {
  if (lines.length == 0) return acc.map(pos => keypad[pos.y][pos.x]).join("")
  const newPos = solveOne(keypad, lines[0], x, y)
  return solve(keypad, lines.slice(1), newPos.x, newPos.y, [...acc, newPos])
}

console.log(solve(keypad1, lines, 1, 1))
console.log(solve(keypad2, lines, 0, 2))