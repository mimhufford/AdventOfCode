const minMax = (x, y) => [Math.min(x, y), Math.max(x, y)]
const swap = (x, y) => pwd => pwd.substring(0, x) + pwd[y] + pwd.substring(x + 1, y) + pwd[x] + pwd.substring(y + 1)
const swapPositions = (x, y) => pwd => swap(...minMax(x, y))(pwd)
const swapLetters = (a, b) => pwd => swap(...minMax(pwd.indexOf(a), pwd.indexOf(b)))(pwd)
const reverse = (x, y) => pwd => pwd.substring(0, x) + pwd.substring(x, y + 1).split("").reverse().join("") + pwd.substring(y + 1)
const rotate = x => pwd => pwd.substring(pwd.length - (x + pwd.length) % pwd.length) + pwd.substring(0, pwd.length - (x + pwd.length) % pwd.length)
const rotateLetter = a => pwd => rotate(pwd.indexOf(a) >= 4 ? pwd.indexOf(a) + 2 : pwd.indexOf(a) + 1)(pwd)

// shiiiiteee
const move = (x, y) => pwd => {
    const c = pwd[x]
    pwd = pwd.split("")
    pwd.splice(x, 1)
    pwd.splice(y, 0, c)
    return pwd.join("")
}

const input = `
move position 2 to position 1
move position 2 to position 5
move position 2 to position 4
swap position 0 with position 2
move position 6 to position 5
swap position 0 with position 4
reverse positions 1 through 6
move position 7 to position 2
rotate right 4 steps
rotate left 6 steps
rotate based on position of letter a
rotate based on position of letter c
move position 2 to position 0
swap letter d with letter a
swap letter g with letter a
rotate left 6 steps
reverse positions 4 through 7
swap position 6 with position 5
swap letter b with letter a
rotate based on position of letter d
rotate right 6 steps
move position 3 to position 1
swap letter g with letter a
swap position 3 with position 6
rotate left 7 steps
swap letter b with letter c
swap position 3 with position 7
move position 2 to position 6
swap letter b with letter a
rotate based on position of letter d
swap letter f with letter b
move position 3 to position 4
rotate left 3 steps
rotate left 6 steps
rotate based on position of letter c
move position 1 to position 3
swap letter e with letter a
swap letter a with letter c
rotate left 2 steps
move position 6 to position 5
swap letter a with letter g
rotate left 5 steps
reverse positions 3 through 6
move position 7 to position 2
swap position 6 with position 5
swap letter e with letter c
reverse positions 2 through 7
rotate based on position of letter e
swap position 3 with position 5
swap letter e with letter d
rotate left 3 steps
rotate based on position of letter c
move position 4 to position 7
rotate based on position of letter e
reverse positions 3 through 5
rotate based on position of letter h
swap position 3 with position 0
swap position 3 with position 4
move position 7 to position 4
rotate based on position of letter a
reverse positions 6 through 7
rotate based on position of letter g
swap letter d with letter h
reverse positions 0 through 3
rotate right 2 steps
rotate right 6 steps
swap letter a with letter g
reverse positions 2 through 4
rotate based on position of letter e
move position 6 to position 0
reverse positions 0 through 6
move position 5 to position 1
swap position 5 with position 2
rotate right 3 steps
move position 3 to position 1
rotate left 1 step
reverse positions 1 through 3
rotate left 4 steps
reverse positions 5 through 6
rotate right 7 steps
reverse positions 0 through 2
move position 0 to position 2
swap letter b with letter c
rotate based on position of letter d
rotate left 1 step
swap position 2 with position 1
swap position 6 with position 5
swap position 5 with position 0
swap letter a with letter c
move position 7 to position 3
move position 6 to position 7
rotate based on position of letter h
move position 3 to position 0
move position 4 to position 5
rotate left 4 steps
swap letter h with letter c
swap letter f with letter e
swap position 1 with position 3
swap letter e with letter b
rotate based on position of letter e`

const instructions = input.trim().split("\n").map(line => {
    const swapPosRes = line.match(/swap position (.) with position (.)/)
    const swapLetRes = line.match(/swap letter (.) with letter (.)/)
    const reverseRes = line.match(/reverse positions (.) through (.)/)
    const rotLetRes = line.match(/rotate based on position of letter (.)/)
    const moveRes = line.match(/move position (.) to position (.)/)
    const rotRes = line.match(/rotate (.+) (.) step/)

    if (swapPosRes) return swapPositions(...swapPosRes.slice(1).map(Number))
    if (swapLetRes) return swapLetters(...swapLetRes.slice(1))
    if (reverseRes) return reverse(...reverseRes.slice(1).map(Number))
    if (rotLetRes) return rotateLetter(rotLetRes[1])
    if (moveRes) return move(...moveRes.slice(1).map(Number))
    if (rotRes) return rotate(Number(rotRes[2]) * (rotRes[1] === "right" ? 1 : -1))
})

const result = instructions.reduce((data, fn) => fn(data), "abcdefgh")

console.log(result)