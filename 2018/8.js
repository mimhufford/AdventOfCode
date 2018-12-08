const input = require("./data").day8.split(' ').map(Number)

const sum = (a, b) => a + b

const build = data => {
    const numChildren = data.shift()
    const numMetadata = data.shift()
    return {
        children: Array(numChildren).fill().map(() => build(data)),
        metadata: Array(numMetadata).fill().map(() => data.shift())
    }
}

const calcValues = node => {
    if (node.children.length === 0)
        node.value = node.metadata.reduce(sum)
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

const metasum = node => node.metadata.reduce(sum) + node.children.map(metasum).reduce(sum, 0)

const tree = build(input)
calcValues(tree)

console.log("Part 1:", metasum(tree))
console.log("Part 2:", tree.value)