const input = require("./data").day7.split('\n')

const graph = input.reduce((result, line) => {
    const prev = line[5]
    const next = line[36]
    result[prev] = result[prev] || { prev: [], next: [] }
    result[next] = result[next] || { prev: [], next: [] }
    result[prev].next.push(next)
    result[next].prev.push(prev)
    return result
}, {})

const solve = (options, result = '', visited = new Set()) => {
    options = options.filter(id => !visited.has(id) && graph[id].prev.every(id => visited.has(id))).sort()
    if (options.length == 0) return result
    const cur = options.shift()
    visited.add(cur)
    return solve([...options, ...graph[cur].next], result + cur, visited)
}

console.log("Part 1:", solve(Object.keys(graph).filter(id => graph[id].prev.length == 0)))