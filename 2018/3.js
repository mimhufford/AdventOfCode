const input = require("./data").day3.split('\n')

const grid = []

const overlaps = new Set()
input.forEach(claim => {
    const match = claim.match(/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/)
    const [id, x, y, w, h] = [match[1], Number(match[2]), Number(match[3]), Number(match[4]), Number(match[5])]
    for (let gx = x; gx < x + w; gx++) {
        for (let gy = y; gy < y + h; gy++) {
            grid[gx] = grid[gx] || []
            grid[gx][gy] = grid[gx][gy] || []
            grid[gx][gy].push(id)
            if (grid[gx][gy].length > 1) {
                overlaps.add(gx + ':' + gy)
            }
        }
    }
})

console.log("Part 1:", overlaps.size)