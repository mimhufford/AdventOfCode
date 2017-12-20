const input = require('./data').day20

const particles = input.split('\n').map((line, i) => {
    const data = line.match(/<(.+)>.+<(.+)>.+<(.+)>/)
    const [x, y, z] = data[1].split(',').map(Number)
    const [dx, dy, dz] = data[2].split(',').map(Number)
    const [ddx, ddy, ddz] = data[3].split(',').map(Number)
    return { i, x, y, z, dx, dy, dz, ddx, ddy, ddz }
})

const distance = p => p.x * p.x + p.y * p.y + p.z * p.z

const step = ps => ps.forEach(p => {
    p.dx += p.ddx; p.dy += p.ddy; p.dz += p.ddz
    p.x += p.dx; p.y += p.dy; p.z += p.dz
})

const collide = ps => {
    const positions = new Set()
    const toDelete = new Set()
    const position = p => p.x + ',' + p.y + ',' + p.z
    ps.forEach(p => {
        const pos = position(p)
        if (positions.has(pos)) toDelete.add(pos)
        else positions.add(pos)
    })

    return ps.filter(p => !toDelete.has(position(p)))
}

const findClosest = ps => {
    for (let i = 0; i < 10000; i++) step(ps)
    console.log(particles.reduce((res, cur) => distance(res) > distance(cur) ? cur : res).i)
}

const doCollisions = ps => {
    for (let i = 0; i < 10000; i++) {
        ps = collide(ps)
        step(ps)
    }
    console.log(ps.length)
}

//findClosest(particles)
doCollisions(particles)