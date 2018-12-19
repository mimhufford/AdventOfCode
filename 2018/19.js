const input = require("./data").day19.split('\n')

const ops = {
    addr: (r, a, b, c) => r[c] = r[a] + r[b],
    addi: (r, a, b, c) => r[c] = r[a] + b,
    mulr: (r, a, b, c) => r[c] = r[a] * r[b],
    muli: (r, a, b, c) => r[c] = r[a] * b,
    banr: (r, a, b, c) => r[c] = r[a] & r[b],
    bani: (r, a, b, c) => r[c] = r[a] & b,
    borr: (r, a, b, c) => r[c] = r[a] | r[b],
    bori: (r, a, b, c) => r[c] = r[a] | b,
    setr: (r, a, _, c) => r[c] = r[a],
    seti: (r, a, _, c) => r[c] = a,
    gtir: (r, a, b, c) => r[c] = a > r[b] ? 1 : 0,
    gtri: (r, a, b, c) => r[c] = r[a] > b ? 1 : 0,
    gtrr: (r, a, b, c) => r[c] = r[a] > r[b] ? 1 : 0,
    eqir: (r, a, b, c) => r[c] = a == r[b] ? 1 : 0,
    eqri: (r, a, b, c) => r[c] = r[a] == b ? 1 : 0,
    eqrr: (r, a, b, c) => r[c] = r[a] == r[b] ? 1 : 0,
}

const run = input => {
    const ipr = Number(input[0][4])
    const ins = input.slice(1).map(i => i.split(' ')).map(i => [i[0], ...i.slice(1).map(Number)])
    const reg = [0, 0, 0, 0, 0, 0]

    while (reg[ipr] >= 0 && reg[ipr] < ins.length) {
        const ip = reg[ipr]
        ops[ins[ip][0]](reg, ins[ip][1], ins[ip][2], ins[ip][3])
        reg[ipr]++
    }

    return reg[0]
}

console.log("Part 1:", run(input))
console.log("Part 2:", 30481920)

/*

// this is the result of hand converting my input
// it's finding the factors of 10551288 and summing them

d = 10551288
a = 0
for (e = 1; e <= d; e++) {
    for (b = 1; b <= d; b++) {
        if (b * e == d) {
            a += e
        }
    }
}

console.log("Part 2:", a)

*/