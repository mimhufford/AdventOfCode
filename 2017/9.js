const input = require("./data").day9

let score = 0
let depth = 0
let junk = 0
let garbage = false

for (let i = 0; i < input.length; ++i) {
    const c = input[i]

    if (c == '!') i++
    else if (garbage && c != '>') junk++
    else if (c == '<') garbage = true
    else if (c == '>') garbage = false
    else if (c == '}') depth--
    else if (c == '{') score += ++depth
}

console.log(score, junk)