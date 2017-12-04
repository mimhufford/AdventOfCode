/*
 37 36 35 34 33 32 31
 38 17 16 15 14 13 30
 39 18  5  4  3 12 29
 40 19  6  1  2 11 28
 41 20  7  8  9 10 27
 42 21 22 23 24 25 26
 43 44 45 46 47 48 49
 */

const input = require("./data").day3

const nw_value = n => Math.pow((n - 1) * 2, 2) + 1
const ne_value = n => Math.pow((n - 1) * 2, 2) - ((n * 2) - 3)
const sw_value = n => Math.pow((n * 2) - 1, 2) - ((n - 1) * 2)
const se_value = n => Math.pow((n * 2) - 1, 2) + 0

const ring = n => Math.floor(Math.ceil(Math.sqrt(n)) / 2 + 1)
const diag_dist = n => (n - 1) * 2
const distance_from = n => diag_dist(ring(n)) - diff_from_corner(n)
const diff_from_corner = n =>
    [se_value(ring(n)), ne_value(ring(n)), sw_value(ring(n)), nw_value(ring(n))]
        .map(v => Math.abs(v - n))
        .sort((a, b) => a > b ? 1 : -1)[0]

const spiral_adder = () => {
    const directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    const neighbours = [[1, 1], [1, 0], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, 0], [-1, -1]]

    const grid = {}
    let steps = 1;
    let dir = 0;
    let pos = [0,0]

    for (let i = 0; i < 8; ++i) {
        for (let iteration = 0; iteration < 2; iteration++) {
            for (let step = 0; step < steps; step++) {
                const positions = neighbours.map(c => [c[0] + pos[0], c[1] + pos[1]])
                const value = positions.reduce((sum, next) => parseInt(sum) + (grid[next] ? parseInt(grid[next]) : 0), 0)
                grid[pos] = pos[0] == 0 && pos[1] == 0 ? 1 : value
                pos[0] += directions[dir][0]
                pos[1] += directions[dir][1]
                console.log(value)
            }
            dir = (dir + 1) % 4
        }
        ++steps;
    }
}

console.log(distance_from(input))
spiral_adder()