const cave = { x: 6, y: 797, depth: 11991 }

const map = Array(cave.y + 1).fill().map(y => Array(cave.x + 1))

for (let x = 0; x <= cave.x; x++) {
    for (let y = 0; y <= cave.y; y++) {
        const region = {}
        if (x == 0 && y == 0) region.gi = 0
        else if (x == cave.x && y == cave.y) region.gi = 0
        else if (y == 0) region.gi = x * 16807
        else if (x == 0) region.gi = y * 48271
        else region.gi = map[y][x - 1].el * map[y - 1][x].el
        region.el = (region.gi + cave.depth) % 20183
        region.type = region.el % 3
        map[y][x] = region
    }
}

let risk = 0
for (let x = 0; x <= cave.x; x++) {
    for (let y = 0; y <= cave.y; y++) {
        risk += map[y][x].type
    }
}

console.log("Part 1:", risk)