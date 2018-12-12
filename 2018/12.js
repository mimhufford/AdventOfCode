const input = require("./data").day12

const pots = _ => input.split('\n').shift().substring(15).split('')
    .reduce((result, val, index) => {
        result[index] = val === '#'
        return result
    }, {})


const rules = input.split('\n').slice(2)
    .filter(rule => rule[9] === '#')
    .map(rule => rule.split(' => ')[0].split('').map(c => c === '#'))

const step = pots => {
    const result = {}
    const min = Math.min(...Object.keys(pots).map(Number)) - 2
    const max = Math.max(...Object.keys(pots).map(Number)) + 2
    for (let i = min; i <= max; i++) {
        let potOrNot = false
        for (const rule of rules) {
            const pm2 = pots[i - 2] || false
            const pm1 = pots[i - 1] || false
            const p00 = pots[i + 0] || false
            const pp1 = pots[i + 1] || false
            const pp2 = pots[i + 2] || false
            if (rule[0] === pm2 && rule[1] === pm1 &&
                rule[2] === p00 &&
                rule[3] === pp1 && rule[4] === pp2) {
                potOrNot = true
                break
            }
        }
        result[i] = potOrNot
    }
    return result
}

const evolveForSteps = (pots, steps) => {
    for (let i = 1; i <= steps; i++) pots = step(pots)
    let sum = 0
    for (const pot in pots) if (pots[pot]) sum += Number(pot)
    return sum
}

const calculateSumAt = (pots, steps) => {
    const stepsBeforeStable = 200
    for (let i = 1; i < stepsBeforeStable; i++) pots = step(pots)
    let before = 0; for (const pot in pots) if (pots[pot]) before += Number(pot)
    pots = step(pots)
    let after = 0; for (const pot in pots) if (pots[pot]) after += Number(pot)
    const diff = after - before
    const toAdd = (steps - stepsBeforeStable) * diff
    return after + toAdd
}

console.log("Part 1:", evolveForSteps(pots(), 20))
console.log("Part 2:", calculateSumAt(pots(), 50000000000))