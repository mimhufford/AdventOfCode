const judge = (a, b, am, bm, amt) => {
    let result = 0
    for (let i = 0; i < amt; i++) {
        do { a = a * 16807 % 2147483647 } while (a % am)
        do { b = b * 48271 % 2147483647 } while (b % bm)
        if (a % 65536 == b % 65536) result++
    }
    return result
}

console.log(
    judge(883, 879, 1, 1, 40000000),
    judge(883, 879, 4, 8, 5000000)
)