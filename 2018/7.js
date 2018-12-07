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

const order = (options, result = '', visited = new Set()) => {
    options = options.filter(id => !visited.has(id) && graph[id].prev.every(id => visited.has(id))).sort()
    if (options.length == 0) return result
    const cur = options.shift()
    visited.add(cur)
    return order([...options, ...graph[cur].next], result + cur, visited)
}

console.log("Part 1:", order(Object.keys(graph).filter(id => graph[id].prev.length == 0)))

const workers = Array(5).fill(0).map(i => ({ cur: 0, started: 0 }))
const todo = new Set(Object.keys(graph).filter(id => graph[id].prev.length == 0))
const done = new Set()
let second = 0

while (done.size != 26) {
    const freeWorkers = []

    // finish any jobs and work out who is free
    for (let i = 0; i < workers.length; i++) {
        const w = workers[i]
        if (w.cur === 0) freeWorkers.push(w)
        else if (w.cur.charCodeAt(0) - 4 + w.started === second) {
            done.add(w.cur)
            graph[w.cur].next.forEach(j => todo.add(j))
            w.cur = 0
            freeWorkers.push(w)
        }
    }

    // if there are workers then find and allocate jobs
    for (let i = 0; i < freeWorkers.length; i++) {
        const w = freeWorkers[i]
        const job = Array.from(todo).filter(j => !done.has(j) && graph[j].prev.every(j => done.has(j))).sort()[0]
        if (job) {
            w.cur = job
            w.started = second
            todo.delete(job)
        }
    }

    second += 1
}

console.log("Part 2:", second - 1)