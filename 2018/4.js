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

const generateData = id => {
    const minutes = sleeps[id].reduce((g, c) => { g[c] = g[c] || 0; g[c]++; return g }, {})
    const total = Object.values(minutes).reduce((t, c) => t + c, 0)
    const minute = Object.keys(minutes).reduce((a, b) => minutes[a] > minutes[b] ? a : b)
    return { fav: Number(minute), occ: minutes[minute], total }
}

const data = Object.keys(sleeps).map(id => ({ id: Number(id), data: generateData(id) }))

const sleepiest = data.reduce((a, b) => a.data.total > b.data.total ? a : b)
const commonest = data.reduce((a, b) => a.data.occ > b.data.occ ? a : b)
console.log("Part 1:", sleepiest.id * sleepiest.data.fav)
console.log("Part 2:", commonest.id * commonest.data.fav)