const input = require("./data").day2.split('\n')

const freqs = input.map(id => id.split('').reduce((f, c) => {
    f[c] = (f[c] || 0) + 1; return f
}, {}))

const match2 = freqs.filter(f => new Set(Object.values(f)).has(2))
const match3 = freqs.filter(f => new Set(Object.values(f)).has(3))

console.log("Part 1:", match2.length * match3.length)

const offBy1 = (a, b) => {
    for (let diff = 0, i = 0; i < a.length; i++) {
        if (a[i] != b[i]) diff++
        if (diff > 1) return false
    }
    return true
}

for (let i = 0; i < input.length; i++) {
    for (let j = i + 1; j < input.length; j++) {
        if (offBy1(input[i], input[j])) {
            let result = ''
            for (let c = 0; c < input[i].length; c++)
                if (input[i][c] == input[j][c]) result += input[i][c]
            console.log("Part 2:", result)
            return;
        }
    }
}