const input = require("./data").day2.split('\n')

const freqs = input.reduce((obj, id) => {
    obj[id] = id.split('').reduce((f, c) => {
        f[c] = (f[c] || 0) + 1
        return f
    }, {})
    return obj
}, {})

const match2 = Object.keys(freqs).filter(id => new Set(Object.values(freqs[id])).has(2))
const match3 = Object.keys(freqs).filter(id => new Set(Object.values(freqs[id])).has(3))

console.log("Part 1:", match2.length * match3.length)