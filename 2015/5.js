const input = require('./data').day5.split('\n')

const nice1 = str => {
    const vowels = str.match(/[aeiou]/g)
    const repeat = str.match(/(.)\1/)
    const badPair = str.match(/ab|cd|pq|xy/)
    return vowels && vowels.length >= 3 && repeat && !badPair
}
const nice2 = str => {
    const pairRepeat = str.match(/(..).*\1/)
    const sandwich = str.match(/(.).\1/)
    return pairRepeat && sandwich
}

console.log(input.map(nice1).filter(i => i).length)
console.log(input.map(nice2).filter(i => i).length)