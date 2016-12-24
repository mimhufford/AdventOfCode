'use strict'

const ranges = require('./data').day20.trim().split("\n").map(line => line.match(/(\d+)-(\d+)/).slice(1).map(Number))

const findLowest = i => (ranges.filter(range => range[0] <= i && range[1] >= i).length == 0) ? i : findLowest(i + 1)

console.log(findLowest(0))