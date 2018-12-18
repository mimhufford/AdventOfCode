const grid = Array(52).fill().map(v => Array(52))

require("./data").day18.split('\n').map(l => l.split('')).forEach((l, y) => l.forEach((a, x) => grid[y + 1][x + 1] = a))

const count = acres => acres.reduce((res, cur) => {
    if (cur === '.') res.open++
    else if (cur === '|') res.tree++
    else if (cur === '#') res.yard++
    return res
}, { open: 0, tree: 0, yard: 0 })

const doOneMinute = g => {
    const res = Array(52).fill().map(v => Array(52))
    for (let y = 1; y <= 50; y++) {
        for (let x = 1; x <= 50; x++) {
            const neighbours = [
                g[y - 1][x - 1], g[y - 1][x], g[y - 1][x + 1], g[y][x - 1],
                g[y][x + 1], g[y + 1][x - 1], g[y + 1][x], g[y + 1][x + 1]
            ]
            const counts = count(neighbours)
            switch (g[y][x]) {
                case '.': res[y][x] = counts.tree >= 3 ? '|' : '.'; break
                case '|': res[y][x] = counts.yard >= 3 ? '#' : '|'; break
                case '#': res[y][x] = counts.yard >= 1 && counts.tree >= 1 ? '#' : '.'
            }
        }
    }
    return res
}

doMinutes = (g, minutes) => {
    while (minutes > 0) { g = doOneMinute(g); minutes-- }
    const counts = count(g.map(line => line.join('')).join('').split(''))
    return counts.tree * counts.yard
}

console.log("Part 1:", doMinutes(grid, 10))
console.log("Part 2:", doMinutes(grid, 1000000000))