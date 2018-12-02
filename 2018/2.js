const input = require("./data").day2.split('\n')

const freqs = input.map(id => id.split('').reduce((f, c) => {
    f[c] = (f[c] || 0) + 1; return f
}, {}))

const match2 = freqs.filter(f => new Set(Object.values(f)).has(2))
const match3 = freqs.filter(f => new Set(Object.values(f)).has(3))

console.log("Part 1:", match2.length * match3.length)