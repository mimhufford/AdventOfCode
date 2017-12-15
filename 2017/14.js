const input = `amgozmfv`
const inputs = [...Array(128).keys()].map(i => input + "-" + i)

const hex2bin = str => str.split('').map(i => ('000' + parseInt(i, 16).toString(2)).substr(-4)).join('')

const hash = str => {
    const input = [...str.split("").map((_, i) => str.charCodeAt(i)), 17, 31, 73, 47, 23]
    const repeat = [...Array(6).keys()].forEach(_ => input.push(...input))
    const sparse = twist([...Array(256).keys()], input)
    const dense = []
    for (let index = 0; index < 16; index++)
        dense.push(sparse.slice(index*16, index*16+16).reduce((a,b)=>a^b))
    const hex = dense.map(i => ('0' + i.toString(16)).substr(-2)).join("")
    return hex
}

const twist = (data, lengths, start = 0, skip = 0) => {
    if (lengths.length == 0) return data
    const length = lengths[0]
    const rotated = [...data.slice(start), ...data.slice(0, start)]
    const reverse = [...rotated.slice(0, length).reverse(), ...rotated.slice(length)]
    const restore = [...reverse.slice(data.length - start), ...reverse.slice(0, data.length - start)]
    return twist(restore, lengths.slice(1), (start + length + skip) % data.length, skip + 1)
}

const grid = inputs.map(i => hex2bin(hash(i)))

console.log(grid.join('').split('').filter(i => i == '1').length)