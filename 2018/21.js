let a = 0
let b = 0
let c = 0
let d = 0
let e = 0

c = 123
while (true) {
    c = c & 456
    c = c == 72
    if (c) break
}
c = 0
while (true) {
    b = c | 65536
    c = 10373714
    while (true) {
        e = b & 255
        c += e
        c = c & 16777215
        c *= 65899
        c = c & 16777215
        e = 256 > b
        if (e) break
        e = 0
        while (true) {
            d = e + 1
            d *= 256
            d = d > b
            if (d) break
            e += 1
        }
        b = e
    }
    e = c == a
    if (e) break
}