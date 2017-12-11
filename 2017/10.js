const input = "46,41,212,83,1,255,157,65,139,52,39,254,2,86,0,204"
const lengthsPart1 = input.split(",").map(Number)
const lengthsPart2 = [...input.split("").map((_, i) => input.charCodeAt(i)), 17, 31, 73, 47, 23]
const repeatLengths64Times = [...Array(6).keys()].forEach(_ => lengthsPart2.push(...lengthsPart2))

const twist = (data, lengths, start = 0, skip = 0) => {
    if (lengths.length == 0) return data
    const length = lengths[0]
    const rotated = [...data.slice(start), ...data.slice(0, start)]
    const reverse = [...rotated.slice(0, length).reverse(), ...rotated.slice(length)]
    const restore = [...reverse.slice(data.length - start), ...reverse.slice(0, data.length - start)]
    return twist(restore, lengths.slice(1), (start + length + skip) % data.length, skip + 1)
}

const twisted = twist([...Array(256).keys()], lengthsPart1)
const sparseHash = twist([...Array(256).keys()], lengthsPart2)
const denseHash = []
for (let index = 0; index < 16; index++) denseHash.push(sparseHash.slice(index*16, index*16+16).reduce((a,b)=>a^b))
const checksum = twisted[0] * twisted[1]
const hexHash = denseHash.map(i => ('0' + i.toString(16)).substr(-2)).join("")

console.log(checksum, hexHash)