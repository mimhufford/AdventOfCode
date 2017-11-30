const md5 = require('md5')

const input = "uqwqemis"

// generate [0, 1, 2, 3, ..., n]   like python's range()
// const numArray = [...Array(10000000).keys()]    // far too slow

// this does work but just isn't quick enough
// const password = numArray.map(i => md5(input + i)).filter(h => h.match(/^00000/)).map(h => h[5]).join("").slice(0, 8)

let password = ""
let index = 4515059 // first index of a 00000xxxxx
while (password.length < 8) {
    if (md5(input + index).match(/^00000/)) {
        password += md5(input + index)[5]
        console.log(password, index)
    }
    index++
}

console.log(password)