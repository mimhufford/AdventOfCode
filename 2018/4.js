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

const sleepiest = Object.keys(sleeps).reduce((a, b) => sleeps[a].length > sleeps[b].length ? a : b)
const minutes = sleeps[sleepiest].reduce((g, c) => { g[c] = g[c] || 0; g[c]++; return g }, {})
const minute = Object.keys(minutes).reduce((a, b) => minutes[a] > minutes[b] ? a : b)
console.log("Part 1:", sleepiest * minute)