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

runProgram(state)
console.log(state.muls)