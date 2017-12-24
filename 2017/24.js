const data = require('./data').day24.trim().split('\n').map(p => p.split('/').map(Number))

const solve = (n, pairs, route = "") => {
    const matches = []
    for (pair of pairs) {
        if (pair[0] == n || pair[1] == n) {
            const match = pair[1] == n ? pair.reverse() : pair
            const rest = pairs.filter(it => it !== pair)
            matches.push({ match, n, rest: solve(match[1], rest, route + "," + match) })
        }
    }
    routes.push(route.slice(1).split(',').map(Number))
    strengths.push(route.slice(1).split(',').map(Number).reduce((a, b) => a + b))
    return matches
}

const strengths = []
const routes = []

solve(0, data)
console.log(strengths.reduce((a, b) => a > b ? a : b))

const maxLength = routes.map(r => r.length).reduce((a, b) => a > b ? a : b)
const routesWithMaxLength = routes.filter(r => r.length == maxLength)
const maxLengthStrengths = routesWithMaxLength.map(r => r.reduce((a, b) => a + b))
const maxLengthMaxStrength = maxLengthStrengths.reduce((a, b) => a > b ? a : b)
console.log(maxLengthMaxStrength)