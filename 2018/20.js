const input = require("./data").day20

const map = {}
const pStack = []
const sStack = []
let x = 0, y = 0, s = 0

for (const c of input.substring(1, input.length - 1)) {
    switch (c) {
        case 'N': map[`${x},${--y}`] = Math.min(map[`${x},${y}`] || 99999, ++s); break
        case 'E': map[`${++x},${y}`] = Math.min(map[`${x},${y}`] || 99999, ++s); break
        case 'S': map[`${x},${++y}`] = Math.min(map[`${x},${y}`] || 99999, ++s); break
        case 'W': map[`${--x},${y}`] = Math.min(map[`${x},${y}`] || 99999, ++s); break
        case '(': pStack.push([x, y]); sStack.push(s); break
        case ')': [x, y] = pStack.pop(); s = sStack.pop(); break
        case '|': [x, y] = pStack[pStack.length - 1]; s = sStack[sStack.length - 1]
    }
}

console.log("Part 1:", Math.max(...Object.values(map)))
console.log("Part 2:", Object.values(map).filter(v => v >= 1000).length)