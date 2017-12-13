const input = require("./data").day12.split('\n')
    .map(line => line.match(/(\d+) <-> (.+)/))
    .reduce((obj, match) => {
        obj[match[1]] = match[2].split(',').map(s => s.trim())
        return obj
    }, {})

const howManyInGroup = (data, root) => {
    const unchecked = [root]
    const group = new Set()

    while (unchecked.length > 0) {
        const node = unchecked.pop()
        group.add(node)
        data[node].forEach(n => { if (!group.has(n)) unchecked.push(n) })
    }

    return group.size
}

console.log(howManyInGroup(input, '0'))