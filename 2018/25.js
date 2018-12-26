const input = require('./data').day25.split('\n')

const matrix = Array(input.length).fill().map(_ => [])
const points = input.map(line => line.split(',').map(Number))

for (let i = 0; i < input.length; i++)
    for (let j = 0; j < input.length; j++)
        matrix[i][j] = points[i].reduce((d, _, k) => d + Math.abs(points[i][k] - points[j][k]), 0) <= 3

const findConstellations = (matrix, index) => {
    let found = 0
    for (let i = 0; i < input.length; i++) {
        if (matrix[index][i] === true) {
            matrix[index][i] = false
            found = 1
            findConstellations(matrix, i)
        }
    }
    return found
}

const numConstellations = input.reduce((r, c, i) => r + findConstellations(matrix, i), 0)

console.log("Part 1:", numConstellations)