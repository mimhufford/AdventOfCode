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
    else if (c == '}') depth -= garbage ? 0 : 1
    else if (c == '{') {
        depth += garbage ? 0 : 1
        score += garbage ? 0 : depth
    }
}

console.log(score, junk)