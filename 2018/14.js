const generate = limit => {
    const scores = [3, 7]
    const elves = [0, 1]
    while (scores.length <= limit + 10) {
        const e1 = scores[elves[0]]
        const e2 = scores[elves[1]]
        scores.push(...(e1 + e2).toString().split('').map(Number))
        elves[0] = (elves[0] + e1 + 1) % scores.length
        elves[1] = (elves[1] + e2 + 1) % scores.length
        //console.log(scores.map((s, i) => i == elves[0] ? `(${s})` : i == elves[1] ? `[${s}]` : s).join(' '))
    }
    return scores.slice(limit, limit + 10).join('')
}

console.log(generate(9) === "5158916779")
console.log(generate(5) === "0124515891")
console.log(generate(18) === "9251071085")
console.log(generate(2018) === "5941429882")
console.log(generate(110201))