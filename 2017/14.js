const input = `amgozmfv`
const inputs = [...Array(128).keys()].map(i => input + "-" + i)

const hex2bin = str => str.split('').map(i => ('000' + parseInt(i, 16).toString(2)).substr(-4)).join('')

const hash = str => {
    const input = [...str.split("").map((_, i) => str.charCodeAt(i)), 17, 31, 73, 47, 23]
    const repeat = [...Array(6).keys()].forEach(_ => input.push(...input))
    const sparse = twist([...Array(256).keys()], input)
    const dense = []
    for (let index = 0; index < 16; index++)
        dense.push(sparse.slice(index * 16, index * 16 + 16).reduce((a, b) => a ^ b))
    const hex = dense.map(i => ('0' + i.toString(16)).substr(-2)).join("")
    return hex
}

const twist = (data, lengths, start = 0, skip = 0) => {
    if (lengths.length == 0) return data
    const length = lengths[0]
    const rotated = [...data.slice(start), ...data.slice(0, start)]
    const reverse = [...rotated.slice(0, length).reverse(), ...rotated.slice(length)]
    const restore = [...reverse.slice(data.length - start), ...reverse.slice(0, data.length - start)]
    return twist(restore, lengths.slice(1), (start + length + skip) % data.length, skip + 1)
}

const grid = inputs.map(i => hex2bin(hash(i))).map(l => l.split(''))

const flood = (grid, row, col) => {
    const check = [[row, col]]

    while (check.length) {
        const cur = check.pop()
        grid[cur[0]][cur[1]] = '0'
        const r = cur[0], c = cur[1]
        const ns = [[r - 1, c], [r + 1, c], [r, c - 1], [r, c + 1]]
            .filter(c => c[0] >= 0 && c[0] < grid.length && c[1] >= 0 && c[1] < grid.length)
        ns.forEach(r => {
            if (grid[r[0]][r[1]] === '1') {
                check.push(r)
                grid[r[0]][r[1]] = '0'
            }
        })
    }
}

let groups = 0
for (let col = 0; col < grid.length; col++) {
    for (let row = 0; row < grid.length; row++) {
        if (grid[row][col] === '1') {
            flood(grid, row, col)
            groups++
        }
    }
}

console.log(groups)