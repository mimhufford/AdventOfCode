const input = 369

const d = {
    buffer: [0],
    p1i: 0,
    p2i: 0,
    p2r: 0,
}

for (let i = 0; i < 2017; i++) {
    d.p1i = (d.p1i + input) % d.buffer.length
    d.buffer.splice(++d.p1i, 0, d.buffer.length)
}

for (let i = 1; i <= 50000000; i++) {
    d.p2i = (d.p2i + 1 + input) % i
    if (d.p2i === 0) d.p2r = i
}

console.log(d.buffer[d.buffer.indexOf(2017) + 1], d.p2r)