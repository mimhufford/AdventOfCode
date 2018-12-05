const input = require("./data").day5.split('')

const react = remove => {
    const filtered = input.filter(unit => unit.toUpperCase() !== remove)
    const result = [filtered[0]]

    for (let i = 1; i < filtered.length - 1; i++) {
        const a = result[result.length - 1]
        const b = filtered[i]

        if (a && a !== b && a.toUpperCase() === b.toUpperCase())
            result.pop()
        else
            result.push(b)
    }

    return result.length + 1
}

console.log("Part 1:", react())
console.log("Part 2:", 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map(react).sort()[0])