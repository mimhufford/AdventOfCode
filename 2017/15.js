const input = [883, 879]

let matches = 0

for (let i = 0; i < 40000000; i++) {
    input[0] *= 16807
    input[1] *= 48271
    input[0] %= 2147483647
    input[1] %= 2147483647

    if (input[0] % 65536 == input[1] % 65536) 
        matches++
}

console.log(matches)