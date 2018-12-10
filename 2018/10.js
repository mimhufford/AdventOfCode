const stars = require("./data").day10.split('\n')
    .map(line => line.match(/(-?\d+)/g).map(Number))
    .map(line => ({ x: line[0], y: line[1], dx: line[2], dy: line[3] }))

for (let prev = {}, i = 0; true; i++) {
    let left = top = Number.POSITIVE_INFINITY, right = bottom = Number.NEGATIVE_INFINITY

    for (const star of stars) {
        star.x += star.dx
        star.y += star.dy
        if (left > star.x) left = star.x; else if (right < star.x) right = star.x
        if (top > star.y) top = star.y; else if (bottom < star.y) bottom = star.y
    }

    const cur = { left, width: right - left, top, height: bottom - top }

    if (cur.width * cur.height > prev.width * prev.height) {
        const sky = Array(prev.height + 1).fill().map(_ => Array(prev.width).fill(' '))
        stars.forEach(s => sky[s.y - s.dy - prev.top][s.x - s.dx - prev.left] = '#')
        console.log("Part 1:"); sky.forEach(line => console.log(line.join('')))
        console.log("Part 2:", i)
        break
    }

    prev = cur
}