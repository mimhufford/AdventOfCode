const input = 'R2, L3, R2, R4, L2, L1, R2, R4, R1, L4, L5, R5, R5, R2, R2, R1, L2, L3, L2, L1, R3, L5, R187, R1, R4, L1, R5, L3, L4, R50, L4, R2, R70, L3, L2, R4, R3, R194, L3, L4, L4, L3, L4, R4, R5, L1, L5, L4, R1, L2, R4, L5, L3, R4, L5, L5, R5, R3, R5, L2, L4, R4, L1, R3, R1, L1, L2, R2, R2, L3, R3, R2, R5, R2, R5, L3, R2, L5, R1, R2, R2, L4, L5, L1, L4, R4, R3, R1, R2, L1, L2, R4, R5, L2, R3, L4, L5, L5, L4, R4, L2, R1, R1, L2, L3, L2, R2, L4, R3, R2, L1, L3, L2, L4, L4, R2, L3, L3, R2, L4, L3, R4, R3, L2, L1, L4, R4, R2, L4, L4, L5, L1, R2, L5, L2, L3, R2, L2'

const turn = (facing, turnDir) => {
  const dirs = ['N','E','S','W']
  const dirVal = (turnDir == "R") ? 1 : (turnDir == "L") ? -1 : 0
  return dirs[(dirs.indexOf(facing) + dirVal + 4) % 4]
}

const move = (x, y, facing, turnDir, amount) => {
  const movement = {
    "N" : [ 0,  1 ],
    "E" : [ 1,  0 ],
    "S" : [ 0, -1 ],
    "W" : [-1,  0 ],
  }

  const newFacing = turn(facing, turnDir)

  return {
    x: x + movement[newFacing][0] * amount,
    y: y + movement[newFacing][1] * amount,
    facing: newFacing,
    turnDir,
    amount
  }
}

const instructions = input
                      .trim()
                      .split(",")
                      .map(s => s.trim())
                      .map(s => [s.slice(0,1), s.slice(1)])
                      .map(i => {return {t: i[0], a: parseInt(i[1])}})

let x = 0
let y = 0
let facing = "N"

instructions.forEach(i => {
  ({x, y, facing} = move(x, y, facing, i.t, i.a))
  console.log(i)
})

console.log({x,y})