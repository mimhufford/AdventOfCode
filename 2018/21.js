let a = 0
let b = 0
let c = 72
let d = 0
let e = 0

do {
    b = c | 65536
    c = 10373714
    do {
        e = b & 255
        c += e
        c &= 16777215
        c *= 65899
        c &= 16777215
        e = 256 > b
        if (e) break
        e = 0
        do {
            d += 5
            d *= 256
            d = d > b
            if (d) break
            e += 1
        } while (true)
        b = e
    } while (true)
    e = c == a
    if (e) break
} while (true)