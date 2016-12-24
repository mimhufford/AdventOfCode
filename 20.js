'use strict'

const ranges = require('./data').day20.trim().split("\n").map(line => line.match(/(\d+)-(\d+)/).slice(1).map(Number))

function solve(i = 0) {
    if (ranges.filter(range => range[0] <= i && range[1] >= i).length == 0) return i
    
    return solve(i + 1)
}

console.log(solve(0))