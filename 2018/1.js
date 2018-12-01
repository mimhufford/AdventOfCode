const input = require("./data").day1

const deltas = input.split('\n').map(Number)

console.log("Part 1:", deltas.reduce((p, c) => p + c))

for (let freq = 0, i = 0, freqs = new Set(); ; i = (i + 1) % deltas.length) {
    freqs.add(freq)
    freq += deltas[i]
    if (freqs.has(freq)) {
        console.log("Part 2:", freq)
        break
    }
}