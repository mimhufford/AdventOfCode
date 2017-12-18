const input = require('./data').day3.split('')

const instruction = {
    'v': p => p.y--,
    '^': p => p.y++,
    '>': p => p.x++,
    '<': p => p.x--,
}

const state = {
    pos: { x: 0, y: 0 },
    map1: { '0,0': 1 },
    map2: { '0,0': 2 },
    santa: { x: 0, y: 0 },
    robot: { x: 0, y: 0 },
}

const move = (i, pos, map) => {
    instruction[input[i]](pos)
    const id = Object.values(pos)
    map[id] = map[id] ? map[id] + 1 : 1
}

for (let i = 0; i < input.length; i += 2) {
    move(i + 0, state.pos, state.map1)
    move(i + 1, state.pos, state.map1)
    move(i + 0, state.santa, state.map2)
    move(i + 1, state.robot, state.map2)
}

console.log(
    Object.values(state.map1).filter(l => l => 1).length,
    Object.values(state.map2).filter(l => l => 1).length,
)