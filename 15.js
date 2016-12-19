'use strict'

const input = `Disc #1 has 13 positions; at time=0, it is at position 11.
               Disc #2 has 5 positions; at time=0, it is at position 0.
               Disc #3 has 17 positions; at time=0, it is at position 11.
               Disc #4 has 3 positions; at time=0, it is at position 0.
               Disc #5 has 7 positions; at time=0, it is at position 2.
               Disc #6 has 19 positions; at time=0, it is at position 17.
               EXTRA++ has 11 positions; at time=0, it is at position 0.`

const rotateOnce = discs => discs.map(disc => [disc[0], (disc[1] + 1) % disc[0]])
const isAligned = discs => discs.every(disc => disc[1] === 0)

// [ [ 13, 11 ], [ 5, 0 ], [ 17, 11 ], [ 3, 0 ], [ 7, 2 ], [ 19, 17 ] ]
const initialState = input.trim().split("\n").map(disc => disc.match(/has (\d+) .+ position (\d+)/).slice(1).map(Number))

// add all the offsets to account for 1s per drop
// [ [ 13, 12 ], [ 5, 2 ], [ 17, 14 ], [ 3, 1 ], [ 7, 0 ], [ 19, 4 ] ]
const rotatedDiscs = initialState.map((disc, index) => [disc[0], (disc[1] + index + 1) % disc[0]])

const findAlignment = (discs, count) => isAligned(discs) ? count : findAlignment(rotateOnce(discs), count + 1)

console.log(findAlignment(rotatedDiscs, 0))