const input = require('./data').day21

const permutations = nr0 => {
    const diag = grid => grid.split('/')[0].split('').map((c, i) => grid.split('/').map(row => row[i]).join('')).join('/')
    const flip = grid => grid.split('/').map(r => r.split('').reverse().join('')).join('/')
    const fr0 = flip(nr0)
    const fr1 = diag(flip(fr0))
    const fr2 = diag(flip(fr1))
    const fr3 = diag(flip(fr2))
    const nr1 = diag(flip(nr0))
    const nr2 = diag(flip(nr1))
    const nr3 = diag(flip(nr2))
    return new Set([nr0, nr1, nr2, nr3, fr0, fr1, fr2, fr3])
}

const divide = (grid, rules) => {
    const rows = grid.split('/')
    const size = rows[0].length % 2 ? 3 : 2
    const groups = rows[0].length / size
    const next = Array.apply(null, Array(groups * (size + 1))).map(_ => [])

    for (let x = 0; x < groups * size; x += size) {
        for (let y = 0; y < groups * size; y += size) {
            const key = size === 2 ?
                rows[x + 0][y + 0] + rows[x + 0][y + 1] + '/' +
                rows[x + 1][y + 0] + rows[x + 1][y + 1] :
                rows[x + 0][y + 0] + rows[x + 0][y + 1] + rows[x + 0][y + 2] + '/' +
                rows[x + 1][y + 0] + rows[x + 1][y + 1] + rows[x + 1][y + 2] + '/' +
                rows[x + 2][y + 0] + rows[x + 2][y + 1] + rows[x + 2][y + 2]

            const data = rules.find(r => r[0].has(key))[1].split('/')
            for (let i = 0; i <= size; i++)
                for (let j = 0; j <= size; j++)
                    next[x + i + x / size][y + j + y / size] = data[i][j]
        }
    }

    return next.map(row => row.join('')).join('/')
}

const enhance = (grid, rules, amount) => {
    for (let i = 0; i < amount; i++) {
        grid = divide(grid, rules)
    }
    return grid
}

const rules = input.split('\n').map(line => line.split(' => ')).map(r => [permutations(r[0]), r[1]])

const part1 = enhance(".#./..#/###", rules, 5).split('').filter(c => c === '#').length
const part2 = enhance(".#./..#/###", rules, 18).split('').filter(c => c === '#').length

console.log(part1)
console.log(part2)