const input = "01111010110010011"
const diskSize = 272

const evolve = data => data + "0" + data.split("").reverse().join("").replace(/1/g, "2").replace(/0/g, "1").replace(/2/g, "0")

const checksum = data => {
    const cs = data.split("").slice(0, data.length / 2).map((d, i) => data[i * 2] + data[i * 2 + 1]).map(c => c[0] == c[1] ? 1 : 0).join("")
    return cs.length % 2 == 1 ? cs : checksum(cs)
}

console.log(checksum([...Array(10)].reduce(evolve, input).substr(0, diskSize)))