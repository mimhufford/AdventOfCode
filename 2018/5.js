const input = require("./data").day5

const react = remove => {
    const result = [input[0]]

    for (let i = 1; i < input.length - 1; i++) {
        const b = input[i]
        if (b.toUpperCase() === remove) continue

        const a = result[result.length - 1]

        if (a && a !== b && a.toUpperCase() === b.toUpperCase())
            result.pop()
        else
            result.push(b)
    }

    return result.length + 1
}

console.log("Part 1:", react())
console.log("Part 2:", 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map(react).sort()[0])