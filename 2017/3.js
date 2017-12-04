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

const nw_value  = n => Math.pow((n-1)*2, 2) + 1
const ne_value  = n => Math.pow((n-1)*2, 2) - ((n*2)-3)
const sw_value  = n => Math.pow((n*2)-1, 2) - ((n-1)*2)
const se_value  = n => Math.pow((n*2)-1, 2) + 0

const diag_dist = n => (n-1)*2
const ring = n => Math.floor(Math.ceil(Math.sqrt(n)) / 2 + 1)
const diff_from_corner = n => {
    const r = ring(n)
    return [se_value(r), ne_value(r), sw_value(r), nw_value(r)]
            .map(v => Math.abs(v - n))
            .sort((a, b) => a > b ? 1 : -1)[0]
}
const distance_from = n => diag_dist(ring(n)) - diff_from_corner(n)

console.log(distance_from(input))