const input = require("./data").day11.split(',')

const cancelOpposites = (steps, a, b) => {
    if (steps[a] >= steps[b]) {
        steps[a] -= steps[b]
        steps[b] = 0
    } else {
        steps[b] -= steps[a]
        steps[a] = 0
    }
}

const cancelPart = (steps, a, b, c) => {
    if (steps[a] >= steps[b]) {
        steps[a] -= steps[b]
        steps[c] += steps[b]
        steps[b] = 0
    }
}

const calculateDistance = path => {
    const steps = { n: 0, ne: 0, se: 0, s: 0, sw: 0, nw: 0 }
    path.forEach(dir => steps[dir]++)
    cancelOpposites(steps, 'n', 's')
    cancelOpposites(steps, 'ne', 'sw')
    cancelOpposites(steps, 'nw', 'se')
    cancelPart(steps, 'n', 'se', 'ne')
    cancelPart(steps, 'n', 'sw', 'nw')
    cancelPart(steps, 's', 'ne', 'se')
    cancelPart(steps, 's', 'nw', 'sw')
    return steps.n + steps.ne + steps.nw + steps.s + steps.se + steps.sw
}
    
let furthest = 0

for (let i = 0; i < input.length; i++) {
    furthest = Math.max(furthest, calculateDistance(input.slice(i)))
}

console.log(calculateDistance(input), furthest)