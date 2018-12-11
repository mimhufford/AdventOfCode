const findLargestPosition = serial => {
    const grid = []
    for (let y = 1; y <= 300; y++) {
        grid[y] = []
        for (let x = 1; x <= 300; x++)
            grid[y][x] = Math.floor(((x + 10) * y + serial) * (x + 10) / 100) % 10 - 5
    }

    let largest = Number.NEGATIVE_INFINITY
    let largestPos = []

    for (let y = 1; y <= 298; y++) {
        for (let x = 1; x <= 298; x++) {
            cumlative = 0
            for (let gy = y; gy < y + 3; gy++)
                for (let gx = x; gx < x + 3; gx++)
                    cumlative += grid[gy][gx]
            if (cumlative > largest) {
                largest = cumlative
                largestPos = [x, y]
            }
        }
    }
    return `${largestPos[0]},${largestPos[1]}`
}

console.log("Part 1:", findLargestPosition(5719))