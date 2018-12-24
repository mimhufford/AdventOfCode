const input = require("./data").day24.split('-')

const parse = data => {
    data = data.trim().split('\n')
    const nums = data.map(g => g.match(/\d+/g).map(Number))
    const imms = data.map(g => g.match(/immune to (.+?)[;|)]/)).map(i => i ? i[1].split(',') : [])
    const weak = data.map(g => g.match(/weak to (.+?)[;|)]/)).map(i => i ? i[1].split(',') : [])
    const type = data.map(g => g.match(/attack that does \d+ (.+) damage/)[1])
    return nums.map((_, i) => ({
        units: nums[i][0],
        hp: nums[i][1],
        immuneTo: imms[i],
        weakTo: weak[i],
        ap: nums[i][2],
        type: type[i],
        initiative: nums[i][3]
    }))
}

const immuneSystem = parse(input[0])
const infection = parse(input[1])


console.log(infection)