const input = require("./data").day7
    .split("\n")
    .map(line => line.match(/(\S+) \((\d+)\)(.*)/))
    .map(match => ({
        id: match[1],
        weight: Number(match[2]),
        aboveMe: match[3].replace(" -> ", "").split(",").map(v => v.trim()).filter(id => id !== "")
    }))

const findBottom = data => {
    const potentialIds = data.map(record => record.id)
    const aboveIds = []
    data.forEach(record => aboveIds.push(...record.aboveMe))
    aboveIds.forEach(id => {
        const index = potentialIds.indexOf(id)
        if (index >= 0) {
            potentialIds.splice(index, 1)
        }
    })
    return potentialIds[0]
}

const bottom = findBottom(input)
console.log(bottom)

const allIds = input.map(r => r.id)

const calcWeight = id => {
    const record = input.filter(r => r.id == id)[0]
    if (!record) return id
    if (record.aboveMe.length == 0) return record.weight
    return record.weight + record.aboveMe.reduce((a, b) => calcWeight(a) + calcWeight(b))
}

const isBalanced = id => {
    const record = input.filter(r => r.id == id)[0]
    const childWeights = record.aboveMe.map(calcWeight).sort()
    return childWeights.length == 0 || childWeights[0] == childWeights[childWeights.length - 1]
}

const unbalanced = allIds
    .map(id => [id, isBalanced(id)])
    .filter(it => !it[1]).map(it => [it[0], calcWeight(it[0])])
    .reduce((a, b) => a[1] < b[1] ? a : b)
const weights = input
    .filter(r => r.id == unbalanced[0])[0]
    .aboveMe.map(id => [id, calcWeight(id)])
const oddOneOut = weights
    .map(r => [r, weights.filter(r2 => r2[1] == r[1]).length])
    .filter(r => r[1] == 1)
    .map(r => input.filter(i => i.id == r[0][0])[0])[0]
const sorted = weights.map(it=>it[1]).sort()
const diff = sorted[sorted.length-1] - sorted[0]

console.log(oddOneOut.weight - diff)