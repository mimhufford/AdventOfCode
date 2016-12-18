const input = 'R2, L3, R2, R4, L2, L1, R2, R4, R1, L4, L5, R5, R5, R2, R2, R1, L2, L3, L2, L1, R3, L5, R187, R1, R4, L1, R5, L3, L4, R50, L4, R2, R70, L3, L2, R4, R3, R194, L3, L4, L4, L3, L4, R4, R5, L1, L5, L4, R1, L2, R4, L5, L3, R4, L5, L5, R5, R3, R5, L2, L4, R4, L1, R3, R1, L1, L2, R2, R2, L3, R3, R2, R5, R2, R5, L3, R2, L5, R1, R2, R2, L4, L5, L1, L4, R4, R3, R1, R2, L1, L2, R4, R5, L2, R3, L4, L5, L5, L4, R4, L2, R1, R1, L2, L3, L2, R2, L4, R3, R2, L1, L3, L2, L4, L4, R2, L3, L3, R2, L4, L3, R4, R3, L2, L1, L4, R4, R2, L4, L4, L5, L1, R2, L5, L2, L3, R2, L2'

const move = (turn, amount) => ({x, y, facing}) => {
  const directions = ['N', 'E', 'S', 'W']
  const nowFacing = directions[(directions.indexOf(facing) + (turn == "R" ? 1 : 3)) % 4]
  const movement = { "N": [0, amount], "E": [amount, 0], "S": [0, -amount], "W": [-amount, 0] }
  return { x: x + movement[nowFacing][0], y: y + movement[nowFacing][1], facing: nowFacing }
}

const finalPosition = input.trim().split(",")
  .map(s => s.trim())
  .map(s => [s.slice(0, 1), parseInt(s.slice(1))])
  .map(i => move(i[0], i[1]))
  .reduce((data, moveFn) => moveFn(data), { x: 0, y: 0, facing: "N" })

console.log(finalPosition)