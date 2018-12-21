let a = 0
let b = 0
let c = 0
let e = 0

while (true) {
    b = c | 65536
    c = 10373714
    while (true) {
        c = c + (b & 255)
        c = c & 16777215
        c *= 65899
        c = c & 16777215
        if (256 > b) break
        e = 0
        while (true) {
            if ((e + 1) * 256 > b) break
            e += 1
        }
        b = e
    }
    if (c == a) break
}