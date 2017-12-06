const input = require("./data").day6.split('\t').map(Number)

const bankWithMostBlocks = banks => banks
    .map((blocks, index) => [index, blocks])
    .sort((a, b) => a[1] > b[1] ? -1 : a[1] < b[1] ? 1 : a[0] < b[0] ? -1 : 1)[0][0]

const redistributeHighestBank = banks => {
    const startBank = bankWithMostBlocks(banks)
    const redistributeAmount = banks[startBank]
    banks[startBank] = 0
    for (let bank = startBank + 1; bank < redistributeAmount + startBank + 1; bank++) {
        const currentBank = bank % banks.length
        banks[currentBank]++
    }
}

const iterationsBeforeMatch = banks => {
    const configurations = {}
    configurations[banks.join()] = 0
    for (let iterations = 1; true; iterations++) {
        redistributeHighestBank(banks)
        if (configurations[banks.join()] != undefined) {
            return {
                part1: iterations,
                part2: iterations - configurations[banks.join()]
            }
        }
        configurations[banks.join()] = iterations
    }
}

console.log(iterationsBeforeMatch([...input]))