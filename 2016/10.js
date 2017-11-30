const input = require("./data").day10

const seed = input.trim().split("\n").filter(line => line[0] === "v").map(line => {
    const match = line.match(/value (\d+) goes to (.+)/)
    return {
        id: match[2],
        value: parseInt(match[1])
    }
})

const data = input.trim().split("\n").filter(line => line[0] !== "v").map(line => {
    const match = line.match(/bot (\d+) gives low to (.+ \d+) and high to (.+)/)
    return {
        id: "bot " + match[1],
        lo: match[2],
        hi: match[3],
        values: [...seed.filter(s => s.id === "bot " + match[1]).map(s => s.value)]
    }
})

const solve = data => {
    const moves = data.filter(bot => bot.values.length == 2)

    if (moves.length == 0) return data

    const [lo, hi] = [Math.min(moves[0].values[0], moves[0].values[1]), Math.max(moves[0].values[0], moves[0].values[1])]

    if (lo === 17 && hi === 61) console.log(moves[0].id)

    return solve(data.filter(bot => bot.id !== moves[0].id)
        .map(bot => bot.id === moves[0].lo ? { id: bot.id, lo: bot.lo, hi: bot.hi, values: [...bot.values, lo] } : bot)
        .map(bot => bot.id === moves[0].hi ? { id: bot.id, lo: bot.lo, hi: bot.hi, values: [...bot.values, hi] } : bot)
    )
}

console.log(solve([...data, { id: 'output 0', values: [] }, { id: 'output 1', values: [] }, { id: 'output 2', values: [] }]))