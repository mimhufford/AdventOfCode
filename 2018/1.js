const input = require("./data").day1

const deltas = input.split('\n').map(Number)

console.log("Part 1:", deltas.reduce((p, c) => p + c))

for (let freq = 0, i = 0, seen = {}; ; i = (i + 1) % deltas.length) {
    seen[freq] = seen[freq] + 1 || 1
    freq += deltas[i]
    if (seen[freq] === 1) {
        console.log("Part 2:", freq)
        break
    }
}