const data = require('./data').day24.trim().split('\n').map(p => p.split('/').map(Number))

const strengths = []
const solve = (n, pairs, route = "") => {
    const matches = []
    for (pair of pairs) {
        if (pair[0] == n || pair[1] == n) {
            const match = pair[1] == n ? pair.reverse() : pair
            const rest = pairs.filter(it => it !== pair)
            matches.push({ match, n, rest: solve(match[1], rest, route + "," + match) })
        }
    }
    strengths.push(route.slice(1).split(',').map(Number).reduce((a, b) => a + b))
    return matches
}

solve(0, data)
console.log(strengths.reduce((a, b) => a > b ? a : b))