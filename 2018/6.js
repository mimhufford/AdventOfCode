const input = require("./data").day6

const coords = input.split('\n').map(l => l.split(', ').map(Number))

const dist = (x, y, coord) => Math.abs(x - coord[0]) + Math.abs(y - coord[1])

const cells = []
const infinites = new Set()
let safe = 0

const [x0, x1, y0, y1] = coords.reduce((r, c) =>
    [Math.min(r[0], c[0]), Math.max(r[1], c[0]), Math.min(r[2], c[1]), Math.max(r[3], c[1])],
    [Number.MAX_VALUE, Number.MIN_VALUE, Number.MAX_VALUE, Number.MIN_VALUE])

for (let y = y0; y <= y1; y++) {
    for (let x = x0; x <= x1; x++) {
        let lowestIndex = new Set()
        let lowestDistance = Number.MAX_VALUE
        let totalDistance = 0
        for (let i = 0; i < coords.length; i++) {
            const distance = dist(x, y, coords[i])
            totalDistance += distance
            if (distance < lowestDistance) {
                lowestIndex.clear()
                lowestIndex.add(i)
                lowestDistance = distance
            } else if (distance === lowestDistance) {
                lowestIndex.add(i)
            }
        }
        if (totalDistance < 10000) safe++
        if (lowestIndex.size === 1) {
            const index = Array.from(lowestIndex)[0]
            cells.push(index)
            if (x === x0 || y === y0 || x === x1 || y === y1)
                infinites.add(index)
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
console.log("Part 2:", safe)