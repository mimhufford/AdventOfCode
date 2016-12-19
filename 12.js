'use strict' // for --harmony-tailcalls

const input = `cpy 1 a
cpy 1 b
cpy 26 d
jnz c 2
jnz 1 5
cpy 7 c
inc d
dec c
jnz c -2
cpy a c
inc a
dec b
jnz b -2
cpy c b
dec d
jnz d -6
cpy 16 c
cpy 17 d
inc a
dec d
jnz d -2
dec c
jnz c -5`

const cpy = (valOrReg, register) => state => [Object.assign(state, { [register]: state[valOrReg] || Number(valOrReg) }), 1]
const inc = register => state => [Object.assign(state, { [register]: state[register] + 1 }), 1]
const dec = register => state => [Object.assign(state, { [register]: state[register] - 1 }), 1]
const jnz = (valOrReg, value) => state => [state, (state[valOrReg] || Number(valOrReg) || 0) === 0 ? 1 : Number(value)]

const generateInstruction = text => {
    const cpyRes = text.match(/cpy (.+) (.+)/)
    const incRes = text.match(/inc (.+)/)
    const decRes = text.match(/dec (.+)/)
    const jnzRes = text.match(/jnz (.+) (.+)/)

    if (cpyRes) return cpy(cpyRes[1], cpyRes[2])
    if (incRes) return inc(incRes[1])
    if (decRes) return dec(decRes[1])
    if (jnzRes) return jnz(jnzRes[1], jnzRes[2])
}

const instructions = input.split("\n").map(generateInstruction)

const interpret = (instructions, line = 0, state = {}) => {
    if (line >= instructions.length) return state

    const [newState, lineDelta] = instructions[line](state)
    return interpret(instructions, line + lineDelta, newState)
}

console.log(interpret(instructions))
console.log(interpret(instructions, 0, { c: 1 }))