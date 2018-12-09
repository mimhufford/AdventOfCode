const highscore = (players, marbles) => {
    const score = Array(players).fill(0)
    const board = [0]
    for (let cur = 0, player = 1, marble = 1; marble <= marbles; marble++) {
        if (marble % 23 === 0) {
            score[player] += marble
            cur = (cur - 7) % board.length
            cur = cur < 0 ? cur + board.length : cur
            score[player] += board.splice(cur, 1)[0]
        } else {
            cur = ((cur + 1) % board.length) + 1
            board.splice(cur, 0, marble)
        }
        player = (player + 1) % players
    }
    return score.reduce((a, b) => a > b ? a : b)
}

console.log("Part 1:", highscore(424, 71482))