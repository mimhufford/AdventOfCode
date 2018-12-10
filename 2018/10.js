const input = require("./data").day10.split('\n')

const stars = input.map(line => line.match(/(-?\d+)/g).map(Number)).map(line => ({
    x: line[0], y: line[1], dx: line[2], dy: line[3]
}))

for (let prev = {}, i = 0; true; i++) {
    let l = t = Number.POSITIVE_INFINITY, r = b = Number.NEGATIVE_INFINITY

    for (const star of stars) {
        star.x += star.dx
        star.y += star.dy
        l = l > star.x ? star.x : l
        t = t > star.y ? star.y : t
        r = r < star.x ? star.x : r
        b = b < star.y ? star.y : b
    }

    const cur = { l, w: r - l, t, h: b - t }

    if (cur.w * cur.h > prev.w * prev.h) {
        const sky = Array(prev.h + 1).fill().map(_ => Array(prev.w).fill(' '))
        stars.forEach(s => sky[s.y - s.dy - prev.t][s.x - s.dx - prev.l] = '#')
        console.log("Part 1:"); sky.forEach(line => console.log(line.join('')))
        console.log("Part 2:", i)
        break
    }

    prev = cur
}