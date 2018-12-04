const input = require("./data").day4.split('\n').sort()

const sleeps = {}
let id, start

for (const line of input) {
    switch (line[25]) {
        case '#': id = line.substr(26).split(' ')[0]; break
        case 'a': start = Number(line.substr(15, 2)); break
        case 'u':
            sleeps[id] = sleeps[id] || []
            const end = Number(line.substr(15, 2))
            for (let m = start; m < end; m++) sleeps[id].push(m)
    }
}

const sleepiestMinute = id => {
    const minutes = sleeps[id].reduce((g, c) => { g[c] = g[c] || 0; g[c]++; return g }, {})
    const total = Object.values(minutes).reduce((t, c) => t + c, 0)
    const minute = Object.keys(minutes).reduce((a, b) => minutes[a] > minutes[b] ? a : b)
    return [Number(minute), minutes[minute], total]
}

const data = Object.keys(sleeps).map(id => ({ id: Number(id), favMin: sleepiestMinute(id) }))

const sleepiest = data.reduce((a, b) => a.favMin[2] > b.favMin[2] ? a : b)
const commonest = data.reduce((a, b) => a.favMin[1] > b.favMin[1] ? a : b)
console.log("Part 1:", sleepiest.id * sleepiest.favMin[0])
console.log("Part 2:", commonest.id * commonest.favMin[0])