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

for (let i = 0; i < 100000; i++) {
    step(particles)
}

const closest = particles.reduce((closest, cur) => distance(closest) > distance(cur) ? cur : closest)

console.log(closest)