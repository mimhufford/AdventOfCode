const generate = (scores, elves) => {
    const e1 = scores[elves[0]], e2 = scores[elves[1]]
    scores.push(...(e1 + e2).toString().split('').map(Number))
    elves[0] = (elves[0] + e1 + 1) % scores.length
    elves[1] = (elves[1] + e2 + 1) % scores.length
}

const getScoresAfter = limit => {
    const scores = [3, 7], elves = [0, 1]
    while (scores.length <= limit + 10) generate(scores, elves)
    return scores.slice(limit, limit + 10).join('')
}

console.log("Part 1:", getScoresAfter(110201))