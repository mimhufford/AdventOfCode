const input = 'iwrupvqb'
const md5 = require('md5')

const firstHashStartingWith = (prefix, key) => {
    for (let i = 0; true; i++) {
        if (md5(key + i).startsWith(prefix)) return i
    }
}

console.log(firstHashStartingWith('00000', input))
console.log(firstHashStartingWith('000000', input))