const highscore = (players, marbles) => {
    const score = Array(players).fill(0)
    let board = { val: 0 }
    board.next = board.prev = board
    for (let marble = 1; marble <= marbles; marble++) {
        if (marble % 23 === 0) {
            const remove = board.prev.prev.prev.prev.prev.prev.prev
            board = remove.prev.next = remove.next
            score[marble % players] += marble + remove.val
        } else {
            const first = board.next
            const second = first.next
            board = { val: marble, prev: first, next: second }
            first.next = second.prev = board
        }
    }
    return Math.max(...score)
}

console.log("Part 1:", highscore(424, 71482))
console.log("Part 2:", highscore(424, 7148200))