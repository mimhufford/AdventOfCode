const input = require("./data").day5.split('\n').map(Number)

// seems like node and v8 don't support TCO any more...
const simulate = (instructions, index = 0, steps = 0) => {
    if (index < 0 || index > instructions.length - 1) return steps
    const newIndex = index + instructions[index]
    instructions[index]++
    return simulate(instructions, newIndex, steps + 1)
}

const nonRecursiveSimulate = (offset) => {
    let instructions = [...input], index = 0, steps = 0
    while (index >= 0 && index < instructions.length) {
        const prevIndex = index
        index += instructions[index]
        instructions[prevIndex] = offset(instructions[prevIndex])
        steps++
    }
    return steps
}

console.log(nonRecursiveSimulate(o => o + 1))
console.log(nonRecursiveSimulate(o => o >= 3 ? o-1 : o+1))