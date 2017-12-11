const input = [...Array(256).keys()]

const twist = (data, lengths, start = 0, skip = 0) => {
    if (lengths.length == 0) return data
    const length = lengths[0]
    const rotated = [...data.slice(start), ...data.slice(0, start)]
    const reverse = [...rotated.slice(0, length).reverse(), ...rotated.slice(length)]
    const restore = [...reverse.slice(input.length - start), ...reverse.slice(0, input.length - start)]
    return twist(restore, lengths.slice(1), (start + length + skip) % input.length, skip + 1)
}

const twisted = twist(input, [46, 41, 212, 83, 1, 255, 157, 65, 139, 52, 39, 254, 2, 86, 0, 204])
const checksum = twisted[0] * twisted[1]

console.log(checksum)