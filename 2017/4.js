const input = require("./data").day4

const unique = list => [...new Set(list)]

const part1 = input.split('\n')
                .map(line => line.split(' '))
                .filter(words => unique(words).length == words.length)
                .length

const part2 = input.split('\n')
                .map(line => line.split(' ').map(word => word.split('').sort().join('')))
                .filter(words => unique(words).length == words.length)
                .length
                

console.log(part1)
console.log(part2)