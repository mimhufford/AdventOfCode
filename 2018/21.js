let a = 0
let c = 0

while (true) {
    let b = c | 65536
    c = 10373714
    while (true) {
        c = c + (b & 255)
        c = c & 16777215
        c *= 65899
        c = c & 16777215
        if (256 > b) break
        b = Math.floor(b / 256)
    }
    if (c == a) break
}