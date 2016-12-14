const input = 'R2, L3, R2, R4, L2, L1, R2, R4, R1, L4, L5, R5, R5, R2, R2, R1, L2, L3, L2, L1, R3, L5, R187, R1, R4, L1, R5, L3, L4, R50, L4, R2, R70, L3, L2, R4, R3, R194, L3, L4, L4, L3, L4, R4, R5, L1, L5, L4, R1, L2, R4, L5, L3, R4, L5, L5, R5, R3, R5, L2, L4, R4, L1, R3, R1, L1, L2, R2, R2, L3, R3, R2, R5, R2, R5, L3, R2, L5, R1, R2, R2, L4, L5, L1, L4, R4, R3, R1, R2, L1, L2, R4, R5, L2, R3, L4, L5, L5, L4, R4, L2, R1, R1, L2, L3, L2, R2, L4, R3, R2, L1, L3, L2, L4, L4, R2, L3, L3, R2, L4, L3, R4, R3, L2, L1, L4, R4, R2, L4, L4, L5, L1, R2, L5, L2, L3, R2, L2'

const turn = (f, t) => {
  const dirs = ['N','E','S','W']
  const dirVal = (t == "R") ? 1 : (t == "L") ? -1 : 0
  return dirs[(dirs.indexOf(f) + dirVal + 4) % 4]
}

const move = ({x, y, f, t, a}) => {
  const movement = {
    "N" : [ 0,  1 ],
    "E" : [ 1,  0 ],
    "S" : [ 0, -1 ],
    "W" : [-1,  0 ],
  }

  const newFacing = turn(f, t)

  return {
    x: x + movement[newFacing][0] * a,
    y: y + movement[newFacing][1] * a,
    f: newFacing
  }
}

const instructions = input.trim().split(",")
                      .map(s => s.trim())
                      .map(s => [s.slice(0,1), s.slice(1)])
                      .map(i => {return {t: i[0], a: parseInt(i[1])}})

const result = instructions.reduce((prev, curr) => move(Object.assign(prev, curr)), { x: 0, y: 0, f: "N" })

//////////////////////////////////////////
