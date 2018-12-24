const bots = require('./data').day23.split('\n').map(l => l.match(/-?\d+/g).map(Number))
const largest = bots.reduce((res, cur) => cur[3] > res[3] ? cur : res)
const inRange = (a, b) => Math.abs(a[0] - b[0]) + Math.abs(a[1] - b[1]) + Math.abs(a[2] - b[2]) <= a[3]

console.log("Part 1:", bots.filter(i => inRange(largest, i)).length)