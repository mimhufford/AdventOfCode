const bots = require('./data').day23.split('\n').map(l => l.match(/-?\d+/g).map(Number)).map(b => ({ x: b[0], y: b[1], z: b[2], r: b[3] }))
const largest = bots.reduce((res, cur) => cur.r > res.r ? cur : res)
const inRange = (a, b) => Math.abs(a.x - b.x) + Math.abs(a.y - b.y) + Math.abs(a.z - b.z) <= a.r

console.log("Part 1:", bots.filter(i => inRange(largest, i)).length)

let min = [Math.min(...bots.map(b => b.x)), Math.min(...bots.map(b => b.y)), Math.min(...bots.map(b => b.z))]
let max = [Math.max(...bots.map(b => b.x)), Math.max(...bots.map(b => b.y)), Math.max(...bots.map(b => b.z))]

let best = [0, []]
for (let size = 4000000; size > 0; size = Math.floor(size / 2)) {
    for (let x = min[0]; x < max[0]; x += size) {
        for (let y = min[1]; y < max[1]; y += size) {
            for (let z = min[2]; z < max[2]; z += size) {
                const count = bots.filter(b => inRange(b, { x, y, z })).length
                if (best[0] < count) best = [count, [x, y, z]]
                else if (best[0] == count) {
                    const dista = Math.abs(best[1][0]) + Math.abs(best[1][1]) + Math.abs(best[1][2])
                    const distb = Math.abs(x) + Math.abs(y) + Math.abs(z)
                    if (dista > distb) best = [count, [x, y, z]]
                }
            }
        }
    }
    min = [best[1][0] - size, best[1][1] - size, best[1][2] - size]
    max = [best[1][0] + size, best[1][1] + size, best[1][2] + size]
}

console.log("Part 2:", Math.abs(best[1][0]) + Math.abs(best[1][1]) + Math.abs(best[1][2]))