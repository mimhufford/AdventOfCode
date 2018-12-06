const input = require("./data").day6

const coords = input.split('\n').map(l => l.split(', ').map(Number))

const cells = []
let safe = 0

const [x0, x1, y0, y1] = coords.reduce((r, c) =>
    [Math.min(r[0], c[0]), Math.max(r[1], c[0]), Math.min(r[2], c[1]), Math.max(r[3], c[1])],
    [Number.MAX_VALUE, Number.MIN_VALUE, Number.MAX_VALUE, Number.MIN_VALUE])

for (let y = y0; y <= y1; y++) {
    for (let x = x0; x <= x1; x++) {
        let lowestIndex = []
        let lowestDistance = Number.MAX_VALUE
        let totalDistance = 0
        for (let i = 0; i < coords.length; i++) {
            const distance = Math.abs(x - coords[i][0]) + Math.abs(y - coords[i][1])
            totalDistance += distance
            if (distance < lowestDistance) {
                lowestIndex = [i]
                lowestDistance = distance
            } else if (distance === lowestDistance) {
                lowestIndex.push(i)
            }
        }
        if (totalDistance < 10000) safe++
        if (lowestIndex.length === 1) {
            const index = lowestIndex[0]
            if (x === x0 || y === y0 || x === x1 || y === y1)
                cells[index] = Number.POSITIVE_INFINITY
            else {
                cells[index] = cells[index] || 0
                cells[index]++
            }
        }
    }
}

console.log("Part 1:", cells.filter(d => Number.isFinite(d)).sort((a, b) => a < b ? 1 : -1)[0])
console.log("Part 2:", safe)