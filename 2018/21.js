let c = 0, s = new Set(), lastSeen

while (true) {
    let b = c | 65536
    if (lastSeen == 0) console.log("Part 1:", c)
    if (s.has(c)) { console.log("Part 2:", lastSeen); break }
    s.add(c)
    lastSeen = c
    c = 10373714
    while (b > 0) {
        c = (((c + (b % 2 ** 8)) % 2 ** 24) * 65899) % 2 ** 24
        b >>= 8
    }
}