const input = require("./data").day23

const state = {
    ip: 0,
    regs: { a: 0, b: 0, c: 0, d: 0, e: 0, f: 0, g: 0, h: 0 },
    muls: 0,
    program: input.split('\n'),
}

const vor = (s, x) => s.regs[x] != undefined ? s.regs[x] : Number(x)

const instructions = {
    'set': s => r => x => s.regs[r] = vor(s, x),
    'sub': s => r => x => s.regs[r] -= vor(s, x),
    'mul': s => r => x => { s.regs[r] *= vor(s, x); s.muls++ },
    'jnz': s => x => y => s.ip += vor(s, x) != 0 ? vor(s, y) - 1 : 0,
}

const runProgram = s => {
    while (s.ip >= 0 && s.ip < s.program.length) {
        const [i, a, b] = s.program[s.ip++].split(' ')
        instructions[i](s)(a)(b)
    }
}

//runProgram(state)
//console.log(state.muls)


// PART 2
let d = e = f = h = 0

for (let b = 106500; b < 123500; b += 17) {
    f = 1
    for (d = 2; d < b; d++) {
        for (e = 2; e < b; e++) {
            if (d * e == b) f = 0
        }
    }
    if (f == 0) h++
}
console.log(h)