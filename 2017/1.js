const input = require("./data").day1

const add    = (a, b) => a + b
const pairs  = (string, offset) => string.split('').map((v, i) => [v, string[(i + offset) % string.length]])
const valOr0 = pair => pair[0] == pair[1] ? parseInt(pair[0]) : 0

const first  = pairs(input,                1).map(valOr0).reduce(add)
const second = pairs(input, input.length / 2).map(valOr0).reduce(add)

console.log(first)
console.log(second)