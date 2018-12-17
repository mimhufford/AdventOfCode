const input = require("./data").day17.split('\n')

let xMin = Number.POSITIVE_INFINITY
let yMin = Number.POSITIVE_INFINITY
let xMax = Number.NEGATIVE_INFINITY
let yMax = Number.NEGATIVE_INFINITY
const grid = []

input.forEach(line => {
    const data = line.match(/(.)=(\d+), .=(\d+)..(\d+)/).slice(1)
    const [val, start, end] = data.slice(1).map(Number)
    grid[val] = grid[val] || []
    for (let i = start; i <= end; i++) {
        grid[i] = grid[i] || []
        grid[data[0] == 'y' ? val : i][data[0] == 'y' ? i : val] = '#'
    }
    xMin = Math.min(xMin, data[0] == 'y' ? start - 1 : val - 1)
    xMax = Math.max(xMax, data[0] == 'y' ? end + 1 : val + 1)
    yMin = Math.min(yMin, data[0] == 'y' ? val : start)
    yMax = Math.max(yMax, data[0] == 'y' ? val : end)
})

for (let y = 0; y <= yMax; y++) {
    grid[y] = grid[y] || []
    for (let x = xMin; x <= xMax; x++)
        grid[y][x] = grid[y][x] == '#' ? '#' : '.'
}

const count = () => {
    let flow = 0, rest = 0
    for (let y = yMin; y <= yMax; y++)
        for (let x = xMin; x <= xMax; x++)
            if (grid[y][x] == '|') flow++
            else if (grid[y][x] == '~') rest++
    return [flow + rest, rest]
}

const fill = (x, y) => {
    if (grid[y][x] != '|') return
    grid[y][x] = '~'
    fill(x - 1, y)
    fill(x + 1, y)
}

const flood = (x, y, dx) => {
    if (y > yMax) return true
    if (grid[y][x] != '.') return grid[y][x] == '|'
    grid[y][x] = '|'
    if (flood(x, y + 1, 0)) return true
    let overflow = false
    overflow |= dx <= 0 && flood(x - 1, y, -1)
    overflow |= dx >= 0 && flood(x + 1, y, +1)
    if (overflow) return true
    if (dx == 0) fill(x, y)
}

flood(500, 0, 0)
console.log("Part 1:", count()[0])
console.log("Part 2:", count()[1])