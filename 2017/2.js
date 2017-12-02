const input = require("./data").day2

const add = (a, b) => a + b
const min = (a, b) => a < b ? a : b
const max = (a, b) => a > b ? a : b

const data = input.split('\n').map(line => line.split('\t').map(Number))
const sum = data.map(row => row.reduce(max) - row.reduce(min)).reduce(add)

console.log(sum)