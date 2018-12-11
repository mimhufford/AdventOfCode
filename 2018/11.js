const findLargestPosition = serial => {
    const grid = []
    for (let y = 1; y <= 300; y++) {
        grid[y] = []
        for (let x = 1; x <= 300; x++)
            grid[y][x] = Math.floor(((x + 10) * y + serial) * (x + 10) / 100) % 10 - 5
    }

    {
        let largest = Number.NEGATIVE_INFINITY
        let largestPos = []

        const size = 3
        for (let y = 1; y <= 301 - size; y++) {
            for (let x = 1; x <= 301 - size; x++) {
                cumlative = 0
                for (let gy = y; gy < y + size; gy++)
                    for (let gx = x; gx < x + size; gx++)
                        cumlative += grid[gy][gx]
                if (cumlative > largest) {
                    largest = cumlative
                    largestPos = [x, y, size]
                }
            }
        }
        console.log(`Part 1: ${largestPos[0]},${largestPos[1]}`)
    }
    {
        let largest = Number.NEGATIVE_INFINITY
        let largestPos = []

        for (let size = 1; size < 300; size++) {
            for (let y = 1; y <= 301 - size; y++) {
                for (let x = 1; x <= 301 - size; x++) {
                    cumlative = 0
                    for (let gy = y; gy < y + size; gy++)
                        for (let gx = x; gx < x + size; gx++)
                            cumlative += grid[gy][gx]
                    if (cumlative > largest) {
                        largest = cumlative
                        largestPos = [x, y, size]
                        console.log(`Part 2: ${largestPos[0]},${largestPos[1]},${largestPos[2]}`)
                    }
                }
            }
        }
    }
}

findLargestPosition(5719)