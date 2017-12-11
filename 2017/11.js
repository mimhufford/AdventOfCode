const input = require("./data").day11.split(',')

const dirs = {
    'n': [-1, 1, 0],
    's': [1, -1, 0],
    'ne': [0, 1, -1],
    'nw': [-1, 0, 1],
    'se': [1, 0, -1],
    'sw': [0, -1, 1],
}

const distance = x => Math.max(Math.abs(x[0]), Math.abs(x[1]), Math.abs(x[2]))

let pos = [0, 0, 0]
let furthest = 0

input.forEach(dir => {
    pos = pos.map((x, i) => x + dirs[dir][i])
    furthest = Math.max(furthest, distance(pos))
})

console.log(distance(pos), furthest);