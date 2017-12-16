const input = require("./data").day16
const robots = 'abcdefghijklmnop'.split('')

const find = (r, d) => d.indexOf(r)
const spin = amt => d => d.slice(-amt).concat(d.slice(0, 16 - amt))
const exchange = (i, j) => d => { const t = d[j]; d[j] = d[i]; d[i] = t; return d }
const partner = (a, b) => d => exchange(find(a, d), find(b, d))(d)

const instructions = input.split(',').map(s =>
    s[0] === 's' ? spin(Number(s.substr(1))) :
        s[0] === 'x' ? exchange(...s.substr(1).split('/').map(Number)) :
            partner(...s.substr(1).split('/'))
)

const finalState = instructions.reduce((d, i) => i(d), [...robots]).join('')

console.log(finalState)