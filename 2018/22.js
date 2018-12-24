const cave = { x: 10, y: 10, depth: 510 }

const X = cave.x + 30
const Y = cave.y + 300

const map = Array(Y).fill().map(y => Array(X))
const unvisited = new Set()

for (let x = 0; x < X; x++) {
    for (let y = 0; y < Y; y++) {
        const region = { x, y }
        if (x == 0 && y == 0) region.gi = 0
        else if (x == cave.x && y == cave.y) region.gi = 0
        else if (y == 0) region.gi = x * 16807
        else if (x == 0) region.gi = y * 48271
        else region.gi = map[y][x - 1].el * map[y - 1][x].el
        region.el = (region.gi + cave.depth) % 20183
        region.type = region.el % 3
        region.dist = x == 0 && y == 0 ? 0 : Number.POSITIVE_INFINITY
        region.prev = null
        map[y][x] = region
        unvisited.add(region)

        // generate neighbours
        if (x > 0) { 
            region.w = map[y][x - 1]
            map[y][x - 1].e = region
        }
        if (y > 0) { region.n = map[y - 1][x]; map[y - 1][x].s = region }
    }
}

let risk = 0
for (let x = 0; x <= cave.x; x++) {
    for (let y = 0; y <= cave.y; y++) {
        risk += map[y][x].type
    }
}

// 0 = neither, 1 = climbing gear, 2 = torch
// 0 rocky  = 1 or 2
// 1 wet    = 0 or 1
// 2 narrow = 0 or 2
let inv = 2

while (unvisited.size > 0) {
    const u = Array.from(unvisited).reduce((r, c) => r.dist < c.dist ? r : c)
    unvisited.delete(u)

    if (u.x == cave.x && u.y == cave.y) break

    const ns = []
    if (u.n && !unvisited.has(u.n)) ns.push(u.n)
    if (u.e && !unvisited.has(u.e)) ns.push(u.e)
    if (u.s && !unvisited.has(u.s)) ns.push(u.s)
    if (u.w && !unvisited.has(u.w)) ns.push(u.w)
    for (const n of ns) {
        let cost = u.dist + 1 // costs a minute to get there
        cost += 0
        if (cost < n.dist) {
            n.dist = cost
            n.prev = u
        }
    }
    console.log(unvisited.size)
}




console.log("Part 1:", risk)