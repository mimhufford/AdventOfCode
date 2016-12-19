const input = 3004953

const survivor = n => parseInt((n >>> 0).toString(2).slice(1) + "1", 2)

console.log(survivor(input))