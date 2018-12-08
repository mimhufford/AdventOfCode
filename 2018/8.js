const input = require("./data").day8.split(' ').map(Number)

const build = data => {
    const numChildren = data.shift()
    const numMetadata = data.shift()
    return {
        children: Array(numChildren).fill().map(() => build(data)),
        metadata: Array(numMetadata).fill().map(() => data.shift())
    }
}

const tree = build(input)

const sum = (a, b) => a + b
const metasum = node => node.metadata.reduce(sum) + node.children.map(metasum).reduce(sum, 0)

console.log("Part 1:", metasum(tree))