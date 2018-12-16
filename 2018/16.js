const input = require("./data").day16.split('\n')

const addr = (r, a, b, c) => r[c] = r[a] + r[b]
const addi = (r, a, b, c) => r[c] = r[a] + b
const mulr = (r, a, b, c) => r[c] = r[a] * r[b]
const muli = (r, a, b, c) => r[c] = r[a] * b
const banr = (r, a, b, c) => r[c] = r[a] & r[b]
const bani = (r, a, b, c) => r[c] = r[a] & b
const borr = (r, a, b, c) => r[c] = r[a] | r[b]
const bori = (r, a, b, c) => r[c] = r[a] | b
const setr = (r, a, _, c) => r[c] = r[a]
const seti = (r, a, _, c) => r[c] = a
const gtir = (r, a, b, c) => r[c] = a > r[b] ? 1 : 0
const gtri = (r, a, b, c) => r[c] = r[a] > b ? 1 : 0
const gtrr = (r, a, b, c) => r[c] = r[a] > r[b] ? 1 : 0
const eqir = (r, a, b, c) => r[c] = a == r[b] ? 1 : 0
const eqri = (r, a, b, c) => r[c] = r[a] == b ? 1 : 0
const eqrr = (r, a, b, c) => r[c] = r[a] == r[b] ? 1 : 0

const analyseSamples = () => {
    ops = [addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr]
    let threeOrMore = 0
    for (let line = 0; line < input.length; line++) {
        if (input[line][0] === 'B') {
            const before = input[line++].match(/\d+/g).map(Number)
            const instruction = input[line++].match(/\d+/g).map(Number)
            const after = input[line++].match(/\d+/g).map(Number)
            let matches = 0
            for (const op of ops) {
                const result = [...before]
                const [_, a, b, c] = instruction
                op(result, a, b, c)
                if (result.every((_, i) => result[i] === after[i])) matches++
            }
            if (matches >= 3) threeOrMore++
        }
    }
    return threeOrMore
}

console.log("Part 1:", analyseSamples())