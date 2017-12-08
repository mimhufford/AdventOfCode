const input = require("./data").day8
    .split('\n')
    .map(line => line.match(/(.+) (.+) (-?\d+).+(.+) (.+) (-?\d+)/))
    .map(match => [match[1], match[2], Number(match[3]), match[4], match[5], Number(match[6])])
    .map(match => ({
         r1: match[0], 
        inc: match[1] == 'inc' ? match[2] : -match[2], 
         r2: match[3], 
         op: match[4], 
        val: match[5]
    }))

const registers = {}

input.forEach(i => {
    if (!registers[i.r1]) registers[i.r1] = 0
    if (!registers[i.r2]) registers[i.r2] = 0
    if ((i.op == '>'  && registers[i.r2]  > i.val) ||
        (i.op == '<'  && registers[i.r2]  < i.val) ||
        (i.op == '>=' && registers[i.r2] >= i.val) ||
        (i.op == '<=' && registers[i.r2] <= i.val) ||
        (i.op == '==' && registers[i.r2] == i.val) ||
        (i.op == '!=' && registers[i.r2] != i.val))
    {
        registers[i.r1] += i.inc
    }
})

const largest = Object.values(registers).reduce((a,b) => Math.max(a,b))
console.log(largest)