const input = require("./data").day13.split('\n')
    .map(line => line.match(/(\d+): (\d+)/))
    .reduce((obj, match) => {
        obj[match[1]] = Number(match[2])
        return obj
    }, {})

const scannerIsAtTop = (data, id, s) => data[id] ? s % ((data[id] - 1) * 2) == 0 : false
const last = Object.keys(input).map(Number).reduce((a, b) => Math.max(a, b))

const costOfRun = data => {
    let severity = 0
    for (let i = 0; i <= last; i++) {
        if (scannerIsAtTop(data, i, i)) {
            severity += data[i] * i
        }
    }
    return severity
}

const isClearRun = (data, delay) => {
    for (let i = 0, s = delay; i <= last; i++ , s++) {
        if (scannerIsAtTop(data, i, s)) return false
    }
    return true
}

const findEarliestClearRun = data => {

    for (let delay = 0; true; delay++) {
        if (isClearRun(data, delay)) return delay
    }
}

console.log(costOfRun(input))
console.log(findEarliestClearRun(input))