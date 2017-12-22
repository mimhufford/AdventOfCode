const input = require('./data').day22.split('\n')

const u = { y: 1, x: 0 }, d = { y: -1, x: 0 }, l = { y: 0, x: 1 }, r = { y: 0, x: -1 }
u.l = l; u.r = r; d.l = r; d.r = l; r.l = u; r.r = d; l.l = d; l.r = u;

const grid = {}
const virus = {
    r: (input[0].length - 1) / 2,
    c: (input[0].length - 1) / 2,
    d: d,
    i: 0
}

const get = (grid, row, col) => {
    grid[row] = grid[row] || {}
    return grid[row][col] || 0
}

const set = (grid, row, col, val) => {
    grid[row] = grid[row] || {}
    grid[row][col] = val
}

input.forEach((str, row) => str.split('').forEach((chr, col) => {
    set(grid, row, col, chr === '#' ? 2 : 0)
}))

const v1 = (grid, virus) => {
    const infected = get(grid, virus.r, virus.c) === 2
    set(grid, virus.r, virus.c, infected ? 0 : 2)
    virus.i += infected ? 0 : 1
    virus.d = infected ? virus.d.r : virus.d.l
    virus.r += virus.d.y
    virus.c += virus.d.x
}

const v2 = (grid, virus) => {
    const state = get(grid, virus.r, virus.c)
    set(grid, virus.r, virus.c, (state + 1) % 4)
    virus.i += state == 1 ? 1 : 0
    virus.d = state == 0 ? virus.d.l : state == 2 ? virus.d.r : state == 3 ? virus.d.r.r : virus.d
    virus.r += virus.d.y
    virus.c += virus.d.x
}

const doBursts = (burstFn, amount, grid, virus) => {
    for (let i = 0; i < amount; i++) burstFn(grid, virus)
}

//doBursts(v1, 10000, grid, virus)
doBursts(v2, 10000000, grid, virus)
console.log(virus.i)