const input = require("./data").day7
    .split("\n")
    .map(line => line.match(/(\S+) \((\d+)\)(.*)/))
    .map(match => ({
        id: match[1],
        weight: Number(match[2]),
        aboveMe: match[3].replace(" -> ", "").split(",").map(v => v.trim()).filter(id => id !== "")
    }))

const findBottom = data => {
    const potentialIds = data.map(record => record.id)
    const aboveIds = []
    data.forEach(record => aboveIds.push(...record.aboveMe))
    aboveIds.forEach(id => {
        const index = potentialIds.indexOf(id)
        if (index >= 0) {
            potentialIds.splice(index, 1)
        }
    })
    return potentialIds[0]
}

console.log(findBottom(input))