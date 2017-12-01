const input = require("./data").day1
const _ = require('ramda')

const data = _.aperture(2, input + input[0])
const result = data.map(pair => pair[0] == pair[1] ? parseInt(pair[0]) : 0).reduce((sum, next) => sum + next)
console.log(result);