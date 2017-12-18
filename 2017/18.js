const input = require("./data").day18

const state = {
    t0: { ip: 0, regs: { p: 0 }, queue: [], sent: 0 },
    t1: { ip: 0, regs: { p: 1 }, queue: [], sent: 0 },
    program: input.split('\n'),
}

const vor = (thread, x) => thread.regs[x] ? thread.regs[x] : Number(x)

const instructions = {
    'jgz': t => _ => x => y => t.ip += vor(t, x) > 0 ? vor(t, y) - 1 : 0,
    'set': t => _ => r => x => t.regs[r] = vor(t, x),
    'add': t => _ => r => x => t.regs[r] += vor(t, x),
    'mul': t => _ => r => x => t.regs[r] *= vor(t, x),
    'mod': t => _ => r => x => t.regs[r] %= vor(t, x),
    'snd': t => q => x => _ => { q.push(vor(t, x)); t.sent++ },
    'rcv': t => _ => r => _ => t.regs[r] = t.queue.shift(),
}

const runProgram = s => {
    const runThread = (t, q) => {
        if ((t.ip >= 0 && t.ip < s.program.length && (s.program[t.ip][0] === 'r' && t.queue.length > 0) || s.program[t.ip][0] !== 'r')) {
            const [i, a, b] = s.program[t.ip++].split(' ')
            instructions[i](t)(q)(a)(b)
            return true
        }
    }

    while (runThread(s.t0, s.t1.queue) || runThread(s.t1, s.t0.queue)) { }
}

runProgram(state)
console.log(state.t1)