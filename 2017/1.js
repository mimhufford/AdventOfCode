const input = require("./data").day1

const data1 = input.split('').map((v, i) => [v, input[(i + 1) % input.length]])
const result1 = data1.map(pair => pair[0] == pair[1] ? parseInt(pair[0]) : 0).reduce((sum, next) => sum + next)

const half = input.length / 2;
const data2 = input.split('').map((v, i) => [v, input[(i + half) % input.length]])
const result2 = data2.map(pair => pair[0] == pair[1] ? parseInt(pair[0]) : 0).reduce((sum, next) => sum + next)

console.log(result1)
console.log(result2)