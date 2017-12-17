const input = 369

const d = {
    buffer: [0],
    index: 0,
}

for (let i = 0; i < 2017; i++) {
    d.index = (d.index + input) % d.buffer.length
    d.buffer.splice(++d.index, 0, d.buffer.length)
}

console.log(d.buffer[d.buffer.indexOf(2017) + 1])