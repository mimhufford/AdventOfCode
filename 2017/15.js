const input = [883, 879]

let matches = 0

for (let i = 0; i < 40000000; i++) {
    input[0] *= 16807
    input[1] *= 48271
    input[0] %= 2147483647
    input[1] %= 2147483647

    if (input[0] % 65536 == input[1] % 65536)
        matches++
}

const generate = (start, mul, div) => {
    const result = []
    let val = start
    while (result.length < 5000000) {
        val *= mul
        val %= 2147483647
        if (val % div == 0) result.push(val)
    }
    return result
}

const judge = (a, b) => {
    let result = 0
    for (let i = 0; i < a.length; i++) {
        if (a[i] % 65536 == b[i] % 65536)
            result++
    }
    return result
}

const a = generate(883, 16807, 4)
const b = generate(879, 48271, 8)

console.log(matches, judge(a, b))