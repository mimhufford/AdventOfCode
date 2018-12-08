const input = require("./data").day8.split(' ').map(Number)

const add = (a, b) => a + b

const build = data => {
    const numChildren = data.shift()
    const numMetadata = data.shift()
    const children = Array(numChildren).fill().map(() => build(data))
    const metadata = Array(numMetadata).fill().map(() => data.shift())
    const sum = metadata.reduce(add) + children.map(c => c.sum).reduce(add, 0)
    const value = children.length ?
        metadata.map(i => children[i - 1] ? children[i - 1].value : 0).reduce(add) :
        metadata.reduce(add)
    return { children, metadata, sum, value }
}

const tree = build(input)

console.log("Part 1:", tree.sum)
console.log("Part 2:", tree.value)