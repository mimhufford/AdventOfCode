const startingRow = ".^^^^^.^^^..^^^^^...^.^..^^^.^^....^.^...^^^...^^^^..^...^...^^.^.^.......^..^^...^.^.^^..^^^^^...^."

const evolve = (data) => {
    const row = data[0]
    const triplets = row.split("").map((cell, index) => [row[index - 1] || ".", cell, row[index + 1] || "."].join(""))
    const newRow = triplets.map(previous => ["^^.", ".^^", "^..", "..^"].includes(previous) ? "^" : ".").join("")
    return [newRow, data[1] + newRow.split("").filter(cell => cell === ".").length]
}

const numSafeCells = Array(399999).fill().reduce(evolve, [startingRow, startingRow.split("").filter(cell => cell === ".").length])

console.log(numSafeCells)