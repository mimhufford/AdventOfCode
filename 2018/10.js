const input = require("./data").day10.split('\n')

const stars = input.map(line => line.match(/(-?\d+)/g).map(Number)).map(line => ({
    x: line[0], y: line[1], dx: line[2], dy: line[3]
}))

const calcBounds = stars => {
    const x0 = Math.min(...stars.map(s => s.x))
    const x1 = Math.max(...stars.map(s => s.x)) - x0
    const y0 = Math.min(...stars.map(s => s.y))
    const y1 = Math.max(...stars.map(s => s.y)) - y0
    return { x0, x1, y0, y1 }
}

const findSmallestBounds = stars => {
    let prevBounds = Number.POSITIVE_INFINITY
    for (let i = 0; ; i++) {
        const bounds = calcBounds(stars)
        const curBounds = bounds.x1 * bounds.y1
        if (curBounds > prevBounds) return i - 1
        else prevBounds = curBounds
        for (const star of stars) {
            star.x += star.dx
            star.y += star.dy
        }
    }
}

const drawAfterSeconds = (stars, second) => {
    const sky = new Set()
    for (const star of stars) {
        star.x += second * star.dx
        star.y += second * star.dy
        sky.add(`${star.x},${star.y}`)
    }
    const bounds = calcBounds(stars)
    for (let y = 0; y <= bounds.y1; y++) {
        const line = []
        for (let x = 0; x <= bounds.x1; x++)
            line.push(sky.has(`${x + bounds.x0},${y + bounds.y0}`) ? '#' : ' ')
        console.log(line.join(''))
    }
}

const second = findSmallestBounds(stars.map(s => Object.assign({}, s)))
console.log("Part 1:")
drawAfterSeconds(stars, second)
console.log("Part 2:", second)