const input = require('./data').day19.split('\n')

const state = {
    pos: [input[0].indexOf('|'), 0],
    dir: [0, 1],
    map: input,
    seen: [],
}

const turnDirs = {
    '0,1': [[-1, 0], [1, 0]],
    '0,-1': [[-1, 0], [1, 0]],
    '-1,0': [[0, 1], [0, -1]],
    '1,0': [[0, 1], [0, -1]],
}

const offset = (p, d) => [p[0] + d[0], p[1] + d[1]]
const charAt = (m, p) => m[p[1]][p[0]]

const move = s => {
    const val = charAt(s.map, s.pos)
    const letter = /[A-Z]/.test(val)
    const straight = /-|\|/.test(val)
    const turn = /\+/.test(val)
    if (letter) s.seen.push(val)
    if (turn) {
        const dirs = turnDirs[s.dir]
        const vals = dirs.map(d => charAt(s.map, offset(s.pos, d)))
        s.dir = vals[0] !== ' ' ? dirs[0] : dirs[1]
    }
    s.pos = offset(s.pos, s.dir)
    return val !== ' '
}

while (move(state)) { }

console.log(state.seen.join(''))