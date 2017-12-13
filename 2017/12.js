const input = require("./data").day12.split('\n')
    .map(line => line.match(/(\d+) <-> (.+)/))
    .reduce((obj, match) => {
        obj[match[1]] = match[2].split(',').map(s => s.trim())
        return obj
    }, {})

const programsInGroup = (data, root) => {
    const unchecked = [root]
    const group = new Set()

    while (unchecked.length > 0) {
        const node = unchecked.pop()
        group.add(node)
        data[node].forEach(n => { if (!group.has(n)) unchecked.push(n) })
    }

    return group
}

const howManyGroups = data => {
    let count = 0
    const seen = new Set()

    for (const key in data) {
        if (!seen.has(key)) {
            count++
            programsInGroup(data, key).forEach(k => seen.add(k))
        }
    }

    return count
}

console.log(programsInGroup(input, '0').size)
console.log(howManyGroups(input))