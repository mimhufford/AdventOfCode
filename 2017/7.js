const input = require("./data").day7
    .split("\n")
    .map(line => line.match(/(\S+) \((\d+)\)(.*)/))
    .map(match => ({
        id: match[1],
        weight: Number(match[2]),
        below: match[3].replace(" -> ", "").split(",").filter(id => id !== "")
    }))

console.log(input)