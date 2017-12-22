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
    return grid[row][col]
}

const set = (grid, row, col, val) => {
    grid[row] = grid[row] || {}
    grid[row][col] = val
}

input.forEach((str, row) => str.split('').forEach((chr, col) => {
    set(grid, row, col, chr === '#')
}))

const burst = (grid, virus) => {
    const infected = get(grid, virus.r, virus.c)
    set(grid, virus.r, virus.c, !infected)
    virus.i += infected ? 0 : 1
    virus.d = infected ? virus.d.r : virus.d.l
    virus.r += virus.d.y
    virus.c += virus.d.x
}

const doBursts = (amount, grid, virus) => {
    for (let i = 0; i < amount; i++) {
        burst(grid, virus)
    }
}

doBursts(10000, grid, virus)
console.log(virus.i)