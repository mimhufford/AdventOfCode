const input = require('./data').day25.trim().split('\n')

const generateState = data => {
    const instructions = {
        state: input[0].match(/state (.)/)[1],
        steps: Number(input[1].match(/after (.+) steps/)[1]),
        program: {},
        cursor: 0,
        tape: {}
    }
    for (let i = 3; i < input.length; i += 10) {
        const state = input[i + 0].match(/state (.)/)[1]
        instructions.program[state] = {
            0: {
                write: Number(input[i + 2].match(/value (.)/)[1]),
                dir: input[i + 3].match(/the (.+)\./)[1] == 'left' ? -1 : 1,
                state: input[i + 4].match(/state (.)/)[1],
            },
            1: {
                write: Number(input[i + 6].match(/value (.)/)[1]),
                dir: input[i + 7].match(/the (.+)\./)[1] == 'left' ? -1 : 1,
                state: input[i + 8].match(/state (.)/)[1],
            }
        }
    }
    return instructions
}

const state = generateState(input)

const step = state => {
    const val = state.tape[state.cursor] || 0
    state.tape[state.cursor] = state.program[state.state][val].write
    state.cursor += state.program[state.state][val].dir
    state.state = state.program[state.state][val].state
}

for (let i = 0; i < state.steps; i++) {
    step(state)
}
const ones = Object.values(state.tape).filter(i => i == 1).length

console.log(ones)