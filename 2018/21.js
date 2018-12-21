let a = 7967233
let c = 0

while (c != a) {
    let b = c | 65536
    c = 10373714
    while (true) {
        // add last 8 bits of b onto c
        // increase c keeping to 24 bits
        // shift b right 8 bits
        c += (b & 255)
        c &= 16777215
        c *= 65899
        c &= 16777215
        if (b < 256) break
        b >>= 8
    }
}