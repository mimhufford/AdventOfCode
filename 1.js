const input = 'R2, L3, R2, R4, L2, L1, R2, R4, R1, L4, L5, R5, R5, R2, R2, R1, L2, L3, L2, L1, R3, L5, R187, R1, R4, L1, R5, L3, L4, R50, L4, R2, R70, L3, L2, R4, R3, R194, L3, L4, L4, L3, L4, R4, R5, L1, L5, L4, R1, L2, R4, L5, L3, R4, L5, L5, R5, R3, R5, L2, L4, R4, L1, R3, R1, L1, L2, R2, R2, L3, R3, R2, R5, R2, R5, L3, R2, L5, R1, R2, R2, L4, L5, L1, L4, R4, R3, R1, R2, L1, L2, R4, R5, L2, R3, L4, L5, L5, L4, R4, L2, R1, R1, L2, L3, L2, R2, L4, R3, R2, L1, L3, L2, L4, L4, R2, L3, L3, R2, L4, L3, R4, R3, L2, L1, L4, R4, R2, L4, L4, L5, L1, R2, L5, L2, L3, R2, L2'

const move = (turn, amount) => ({x, y, facing}) => {
  const directions = ['N', 'E', 'S', 'W']
  const nowFacing = directions[(directions.indexOf(facing) + (turn == "R" ? 1 : 3)) % 4]
  const movement = { "N": [0, 1], "E": [1, 0], "S": [0, -1], "W": [-1, 0] }

  return Array(amount - 1).fill().reduce((prev, curr) =>
    // take the previous moves and add on one more based on one evolution of the latest move
    [...prev, { x: prev[prev.length - 1].x + movement[nowFacing][0], y: prev[prev.length - 1].y + movement[nowFacing][1], facing: nowFacing }],
    // start with one movement done
    [{ x: x + movement[nowFacing][0], y: y + movement[nowFacing][1], facing: nowFacing }])
}

const allPositions = input.trim().split(",")
  .map(s => s.trim())
  .map(s => [s.slice(0, 1), parseInt(s.slice(1))])
  .map(i => move(i[0], i[1])) // generate curried move functions for piping data through
  .reduce((data, moveFn) => [...data, ...moveFn(data[data.length - 1])], [{ x: 0, y: 0, facing: "N" }])
  .map(pos => JSON.stringify({ x: pos.x, y: pos.y })) // make results easy to compare

const firstOverlap = allPositions
  .map(pos => [pos, allPositions.filter(search => search === pos).length]) // count occurences
  .filter(occ => occ[1] > 1) // only keep places we've been to more than once
  .shift()

console.log(firstOverlap)