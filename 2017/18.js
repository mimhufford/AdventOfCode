const input = require("./data").day18

const state = {
    ip: 0,
    regs: {},
    latest: undefined,
    program: input.split('\n')
}

const vor = (state, x) => state.regs[x] ? state.regs[x] : Number(x)

const instructions = {
    'jgz': state => (x, y) => state.ip += vor(state, x) > 0 ? vor(state, y) - 1 : 0,
    'set': state => (reg, x) => state.regs[reg] = vor(state, x),
    'add': state => (reg, x) => state.regs[reg] += vor(state, x),
    'mul': state => (reg, x) => state.regs[reg] *= vor(state, x),
    'mod': state => (reg, x) => state.regs[reg] %= vor(state, x),
    'snd': state => x => state.latest = vor(state, x),
    'rcv': state => reg => {
        if (vor(state, reg) > 0) {
            state.regs[reg] = state.latest
            state.ip = -Infinity
        }
    },
}

const run = state => {
    while (state.ip >= 0 && state.ip < input.length) {
        const [i, a, b] = state.program[state.ip].split(' ')
        instructions[i](state)(a, b)
        state.ip++
    }
}

run(state)
console.log(state.latest)