const serial = 5719

const cumulative = []
for (let y = 1; y <= 300; y++) {
    cumulative[y] = []
    for (let x = 1; x <= 300; x++) {
        cumulative[y][x] = Math.floor(((x + 10) * y + serial) * (x + 10) / 100) % 10 - 5
        if (x > 1) cumulative[y][x] += cumulative[y][x - 1]
        if (y > 1) cumulative[y][x] += cumulative[y - 1][x]
        if (y > 1 && x > 1) cumulative[y][x] -= cumulative[y - 1][x - 1]
    }
}

const largestForSize = (min, max) => {
    let largest = Number.NEGATIVE_INFINITY
    let largestPos = []
    for (let size = min; size < (max || min) + 1; size++) {
        for (let y = 1; y <= 300 - size; y++) {
            for (let x = 1; x <= 300 - size; x++) {
                const sum = cumulative[y][x] + cumulative[y + size][x + size] -
                    cumulative[y][x + size] - cumulative[y + size][x]
                if (sum > largest) {
                    largest = sum
                    largestPos = [x, y, size]
                }
            }
        }
    }
    return `${largestPos[0] + 1},${largestPos[1] + 1}${max ? `,${largestPos[2]}` : ''}`
}

console.log("Part 1:", largestForSize(3))
console.log("Part 2:", largestForSize(1, 300))