let a = 7967233
let c = 0

while (c != a) {
    let b = c | 65536
    c = 10373714                                  // 100111100100101001010010
    while (true) {
        c += (b & 255 /* truncate to 8 bit */)
        c &= 16777215 // truncate to 24 bit
        c *= 65899
        c &= 16777215 // truncate to 24 bit
        if (256 > b) break
        b = Math.floor(b / 256)
    }
}