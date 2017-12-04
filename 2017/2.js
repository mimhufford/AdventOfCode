const input = require("./data").day2

const add = (a, b) => a + b

const data = input.split('\n').map(line => line.split('\t').map(Number).sort((a,b) => a < b ? 1 : -1))
const part1 = data.map(row => row[0] - row[row.length - 1]).reduce(add)
const part2 = data
                .map(row => row
                    .map((v1, i1) => row
                        .map((v2, i2) => v1 > v2 ? v1 % v2 == 0 ? v1 / v2 : 0 : 0)
                        .filter(v => v != 0))
                    .filter(a => a.length != 0))
                .map(v => v[0])
                .map(v => v[0])
                .reduce(add)

console.log(part1);
console.log(part2)