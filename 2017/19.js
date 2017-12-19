const map = require('./data').day19.split('\n')

const state = {
    pos: [map[0].indexOf('|'), 0],
    dir: [0, 1],
    seen: [],
    moves: -1,
}

const turnDirs = {
    '0,1': [[-1, 0], [1, 0]],
    '0,-1': [[-1, 0], [1, 0]],
    '-1,0': [[0, 1], [0, -1]],
    '1,0': [[0, 1], [0, -1]],
}

const step = s => {
    const offset = (p, d) => [p[0] + d[0], p[1] + d[1]]
    const charAt = (m, p) => m[p[1]][p[0]]
    const val = charAt(map, s.pos)
    if (/[A-Z]/.test(val)) s.seen.push(val)
    if (val === '+') {
        const dirs = turnDirs[s.dir]
        const vals = dirs.map(d => charAt(map, offset(s.pos, d)))
        s.dir = vals[0] !== ' ' ? dirs[0] : dirs[1]
    }
    s.pos = offset(s.pos, s.dir)
    s.moves++
    return val !== ' '
}

while (step(state)) { }

console.log(state.seen.join(''), state.moves)