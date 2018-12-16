const input = require("./data").day16.split('\n')

const ops = [
    addr = (r, a, b, c) => r[c] = r[a] + r[b],
    addi = (r, a, b, c) => r[c] = r[a] + b,
    mulr = (r, a, b, c) => r[c] = r[a] * r[b],
    muli = (r, a, b, c) => r[c] = r[a] * b,
    banr = (r, a, b, c) => r[c] = r[a] & r[b],
    bani = (r, a, b, c) => r[c] = r[a] & b,
    borr = (r, a, b, c) => r[c] = r[a] | r[b],
    bori = (r, a, b, c) => r[c] = r[a] | b,
    setr = (r, a, _, c) => r[c] = r[a],
    seti = (r, a, _, c) => r[c] = a,
    gtir = (r, a, b, c) => r[c] = a > r[b] ? 1 : 0,
    gtri = (r, a, b, c) => r[c] = r[a] > b ? 1 : 0,
    gtrr = (r, a, b, c) => r[c] = r[a] > r[b] ? 1 : 0,
    eqir = (r, a, b, c) => r[c] = a == r[b] ? 1 : 0,
    eqri = (r, a, b, c) => r[c] = r[a] == b ? 1 : 0,
    eqrr = (r, a, b, c) => r[c] = r[a] == r[b] ? 1 : 0,
]

const idToOp = []
let threeOrMore = 0
for (let line = 0; line < input.length; line++) {
    if (input[line][0] === 'B') {
        const before = input[line++].match(/\d+/g).map(Number)
        const instruction = input[line++].match(/\d+/g).map(Number)
        const after = input[line++].match(/\d+/g).map(Number)
        let matches = 0
        for (const op of ops) {
            const result = [...before]
            const [i, a, b, c] = instruction
            op(result, a, b, c)
            if (result.every((_, i) => result[i] === after[i])) {
                matches++
                idToOp[i] = idToOp[i] || new Set()
                idToOp[i].add(op)
            }
        }
        if (matches >= 3) threeOrMore++
    }
}

while (!idToOp.every(s => s.size === 1)) {
    const solvedOps = idToOp.filter(s => s.size === 1).map(s => Array.from(s)[0])
    for (const unsolvedOp of idToOp)
        if (unsolvedOp.size > 1)
            for (const op of solvedOps)
                unsolvedOp.delete(op)
}

const sortedOps = idToOp.map(set => Array.from(set)[0])

const registers = [0, 0, 0, 0]
for (let line = 0; line < input.length; line++) {
    if (input[line][0] === 'B') { line += 3; continue }
    if (input[line].length === 0) continue
    const [i, a, b, c] = input[line].match(/\d+/g).map(Number)
    sortedOps[i](registers, a, b, c)
}

console.log("Part 1:", threeOrMore)
console.log("Part 2:", registers[0])