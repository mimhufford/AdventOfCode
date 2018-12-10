const input = require("./data").day10.split('\n')

const stars = input.map(line => line.match(/(-?\d+)/g).map(Number)).map(line => ({
    x: line[0], y: line[1], dx: line[2], dy: line[3]
}))

const calcBounds = stars => {
    let x0 = Number.POSITIVE_INFINITY, y0 = Number.POSITIVE_INFINITY
    let x1 = Number.NEGATIVE_INFINITY, y1 = Number.NEGATIVE_INFINITY
    for (const star of stars) {
        x0 = x0 > star.x ? star.x : x0
        y0 = y0 > star.y ? star.y : y0
        x1 = x1 < star.x ? star.x : x1
        y1 = y1 < star.y ? star.y : y1
    }
    return { x0, x1: x1 - x0, y0, y1: y1 - y0 }
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

const drawAfter = seconds => {
    const sky = new Set()
    for (const star of stars) {
        star.x += seconds * star.dx
        star.y += seconds * star.dy
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

const seconds = findSmallestBounds(stars.map(s => Object.assign({}, s)))
console.log("Part 1:"); drawAfter(seconds)
console.log("Part 2:", seconds)