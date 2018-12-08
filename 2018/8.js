const input = require("./data").day8.split(' ').map(Number)

const add = (a, b) => a + b

const build = data => {
    const numChildren = data.shift()
    const numMetadata = data.shift()
    const children = Array(numChildren).fill().map(() => build(data))
    const metadata = Array(numMetadata).fill().map(() => data.shift())
    const sum = metadata.reduce(add) + children.map(c => c.sum).reduce(add, 0)
    return { children, metadata, sum }
}

const calcValues = node => {
    if (node.children.length === 0)
        node.value = node.metadata.reduce(add)
    else {
        let value = 0
        for (const i of node.metadata) {
            const child = node.children[i - 1]
            if (child) value += calcValues(child)
        }
        node.value = value
    }
    return node.value
}

const tree = build(input)
calcValues(tree)

console.log("Part 1:", tree.sum)
console.log("Part 2:", tree.value)