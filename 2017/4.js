const input = require("./data").day4

const part1 = input.split('\n').filter(line => [...new Set(line.split(' '))].length == line.split(' ').length).length

console.log(part1)