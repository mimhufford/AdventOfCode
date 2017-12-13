const input = require("./data").day13.split('\n')
    .map(line => line.match(/(\d+): (\d+)/))
    .reduce((obj, match) => {
        obj[match[1]] = Number(match[2])
        return obj
    }, {})

const cost = data => {
    const scannerIsAtTop = (data, id, s) => data[id] ? s % ((data[id] - 1) * 2) == 0 : false

    const last = Object.keys(input).map(Number).reduce((a, b) => Math.max(a, b))
    let severity = 0

    for (let i = 0; i <= last; i++) {
        if (scannerIsAtTop(data, i, i)) {
            severity += data[i] * i
        }
    }
    return severity
}

console.log(cost(input))