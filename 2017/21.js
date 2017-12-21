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
    const length = rows[0].length
    const size = length % 2 ? 3 : 2
    const groups = length / size
    const nextSize = groups * (size + 1)
    const next = Array.apply(null, Array(nextSize)).map(_ => [])

    const replace = rule => {
        for (let i = 0; i < rules.length; i++) {
            const [grids, result] = rules[i]
            if (grids.has(rule)) {
                return result
            }
        }
    }

    for (let x = 0; x < groups * size; x += size) {
        for (let y = 0; y < groups * size; y += size) {
            if (size === 2) {
                const key = rows[x + 0][y + 0] + rows[x + 0][y + 1]
                    + '/' + rows[x + 1][y + 0] + rows[x + 1][y + 1]
                const data = replace(key).split('/')
                next[x + 0 + x / size][y + 0 + y / size] = data[0][0]
                next[x + 0 + x / size][y + 1 + y / size] = data[0][1]
                next[x + 0 + x / size][y + 2 + y / size] = data[0][2]
                next[x + 1 + x / size][y + 0 + y / size] = data[1][0]
                next[x + 1 + x / size][y + 1 + y / size] = data[1][1]
                next[x + 1 + x / size][y + 2 + y / size] = data[1][2]
                next[x + 2 + x / size][y + 0 + y / size] = data[2][0]
                next[x + 2 + x / size][y + 1 + y / size] = data[2][1]
                next[x + 2 + x / size][y + 2 + y / size] = data[2][2]
            } else {
                const key = rows[x + 0][y + 0] + rows[x + 0][y + 1] + rows[x + 0][y + 2]
                    + '/' + rows[x + 1][y + 0] + rows[x + 1][y + 1] + rows[x + 1][y + 2]
                    + '/' + rows[x + 2][y + 0] + rows[x + 2][y + 1] + rows[x + 2][y + 2]
                const data = replace(key).split('/')
                next[x + 0 + x / size][y + 0 + y / size] = data[0][0]
                next[x + 0 + x / size][y + 1 + y / size] = data[0][1]
                next[x + 0 + x / size][y + 2 + y / size] = data[0][2]
                next[x + 0 + x / size][y + 3 + y / size] = data[0][3]
                next[x + 1 + x / size][y + 0 + y / size] = data[1][0]
                next[x + 1 + x / size][y + 1 + y / size] = data[1][1]
                next[x + 1 + x / size][y + 2 + y / size] = data[1][2]
                next[x + 1 + x / size][y + 3 + y / size] = data[1][3]
                next[x + 2 + x / size][y + 0 + y / size] = data[2][0]
                next[x + 2 + x / size][y + 1 + y / size] = data[2][1]
                next[x + 2 + x / size][y + 2 + y / size] = data[2][2]
                next[x + 2 + x / size][y + 3 + y / size] = data[2][3]
                next[x + 3 + x / size][y + 0 + y / size] = data[3][0]
                next[x + 3 + x / size][y + 1 + y / size] = data[3][1]
                next[x + 3 + x / size][y + 2 + y / size] = data[3][2]
                next[x + 3 + x / size][y + 3 + y / size] = data[3][3]
            }
        }
    }

    return next.map(row => row.join('')).join('/')
}

const enhance = (grid, rules, amount) => {
    let g = grid
    for (let i = 0; i < amount; i++) {
        g = divide(g, rules)
    }
    return g
}

const rules = input.split('\n').map(line => line.split(' => ')).map(r => [permutations(r[0]), r[1]])

const part1 = enhance(".#./..#/###", rules, 5).split('').filter(c => c === '#').length
const part2 = enhance(".#./..#/###", rules, 18).split('').filter(c => c === '#').length

console.log(part1)
console.log(part2)