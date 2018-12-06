const input = require("./data").day6

const coords = input.split('\n').map(l => l.split(', ').map(Number))

const dist = (x, y, coord) => Math.abs(x - coord[0]) + Math.abs(y - coord[1])

const cells = []
const infinites = new Set()

const x0 = coords.reduce((res, cur) => Math.min(res, cur[0]), Number.MAX_VALUE)
const x1 = coords.reduce((res, cur) => Math.max(res, cur[0]), Number.MIN_VALUE)
const y0 = coords.reduce((res, cur) => Math.min(res, cur[1]), Number.MAX_VALUE)
const y1 = coords.reduce((res, cur) => Math.max(res, cur[1]), Number.MIN_VALUE)

for (let y = y0; y <= y1; y++) {
    for (let x = x0; x <= x1; x++) {
        const distances = coords.map((c, i) => [i, dist(x, y, c)]).sort((a, b) => a[1] > b[1] ? 1 : -1)
        if (distances[0][1] !== distances[1][1]) {
            cells.push(distances[0][0])
            if (x === x0 || y === y0 || x === x1 || y === y1)
                infinites.add(distances[0][0])
        }
    }
}

const counts = cells.reduce((res, cur) => {
    if (infinites.has(cur)) return res
    res[cur] = res[cur] || 0
    res[cur]++
    return res
}, {})

console.log("Part 1:", Object.values(counts).sort((a, b) => a < b ? 1 : -1)[0])