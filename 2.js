// 1 2 3
// 4 5 6
// 7 8 9

const input = `ULL
RRDDD
LURDL
UUUUD`

// Turn into  [ ['U','L','L'], ['R','R','D','D','D'], etc ]
const steps = input.trim().split("\n").map(line => line.split(''))

// Take an x y and direction and spit out the new x and y
const move = ({x, y, d}) => {
  const dx = d == "R" ? 1 : d == "L" ? -1 : 0
  const dy = d == "D" ? 1 : d == "U" ? -1 : 0
  return {
    x: Math.min(Math.max(x + dx, 0), 2),
    y: Math.min(Math.max(y + dy, 0), 2)
  }
}

const result = steps.map(s => s.reduce((prev, curr) => move(Object.assign(prev, curr, {d: curr})), { x: 1, y: 1 }))

console.log(result)