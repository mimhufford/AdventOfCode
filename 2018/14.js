const generate = (scores, elves) => {
    const e1 = scores[elves[0]], e2 = scores[elves[1]]
    scores.push(...(e1 + e2).toString().split('').map(Number))
    elves[0] = (elves[0] + e1 + 1) % scores.length
    elves[1] = (elves[1] + e2 + 1) % scores.length
}

const scoresAfter = limit => {
    const scores = [3, 7], elves = [0, 1]
    while (scores.length <= limit + 10) generate(scores, elves)
    return scores.slice(limit, limit + 10).join('')
}

const recipesUntil = sequence => {
    const scores = [3, 7], elves = [0, 1]
    sequence = sequence.toString()
    const length = -sequence.length
    while (true) {
        generate(scores, elves)
        const pos = scores.slice(length - 1).join('').indexOf(sequence)
        if (pos >= 0) return scores.length + length - 1 + pos
    }
}

console.time()
console.log("Part 1:", scoresAfter(110201))
console.log("Part 2:", recipesUntil(110201))
console.timeEnd()