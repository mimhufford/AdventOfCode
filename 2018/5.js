const input = require("./data").day5

const match = (a, b) => a && a !== b && a.toUpperCase() === b.toUpperCase()

const result = [input[0]]

for (let i = 1; i < input.length - 1; i++) {
    const a = result[result.length - 1]
    const b = input[i]

    if (match(a, b)) result.pop()
    else             result.push(b)
}

console.log("Part 1:", (result.join('') + input[input.length - 1]).length)