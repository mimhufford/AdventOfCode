const input = require("./data").day18

const state = {
    t0: { ip: 0, regs: { p: 0 }, queue: [], sent: 0 },
    t1: { ip: 0, regs: { p: 1 }, queue: [], sent: 0 },
    program: input.split('\n'),
}

const vor = (thread, x) => thread.regs[x] ? thread.regs[x] : Number(x)

const instructions = {
    'jgz': a => _ => x => y => a.ip += vor(a, x) > 0 ? vor(a, y) - 1 : 0,
    'set': a => _ => r => x => a.regs[r] = vor(a, x),
    'add': a => _ => r => x => a.regs[r] += vor(a, x),
    'mul': a => _ => r => x => a.regs[r] *= vor(a, x),
    'mod': a => _ => r => x => a.regs[r] %= vor(a, x),
    'snd': a => b => x => _ => b.queue.push(vor(a, x)),
    'rcv': a => _ => r => _ => a.regs[r] = a.queue.shift(),
}

const runProgram = s => {
    runThread = (ta, tb) => {
        if (ta.ip >= 0 && ta.ip < s.program.length) {
            const [i, a, b] = s.program[ta.ip].split(' ')
            if ((i === 'rcv' && ta.queue.length > 0) || i !== 'rcv') {
                instructions[i](ta)(tb)(a)(b)
                ta.ip++
                ta.sent += i === 'snd' ? 1 : 0
                return true
            }
        }
    }

    while (runThread(s.t0, s.t1) || runThread(s.t1, s.t0)) { }
}

runProgram(state)
console.log(state.t1)