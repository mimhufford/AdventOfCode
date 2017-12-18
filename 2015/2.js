const input = require('./data').day2.split('\n')
    .map(i => i
        .split('x')
        .map(Number)
        .sort((a, b) => a - b))

const paper = ([l, w, h]) => 2 * l * w + 2 * w * h + 2 * h * l + l * w
const ribbon = ([l, w, h]) => l + l + w + w + l * w * h

console.log(
    input.map(paper).reduce((a, b) => a + b),
    input.map(ribbon).reduce((a, b) => a + b)
)