const input = require("./data").day15.split('\n').map(line => line.split(''))

const input0 = `#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######`.split('\n').map(line => line.split(''))

const input2 = `#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######`.split('\n').map(line => line.split(''))

const input1 = `#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########`.split('\n').map(line => line.split(''))

const input3 = `#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######`.split('\n').map(line => line.split(''))

const input4 = `#######
#E.G#.#
#.#G..#
#G.#.G#
#G..#.#
#...E.#
#######`.split('\n').map(line => line.split(''))

const input5 = `#######
#.E...#
#.#..G#
#.###.#
#E#G#G#
#...#G#
#######`.split('\n').map(line => line.split(''))

const doBattle = startingGrid => {
    const map = startingGrid.map(cells => cells.map(cell => cell === '#' ? '#' : '.'))
    const chrs = [
        ...startingGrid.flatMap((cells, y) => cells.map((cell, x) =>
            cell === 'E' ? ({ elf: true, y, x, hp: 200, ap: 3 }) : null)),
        ...startingGrid.flatMap((cells, y) => cells.map((cell, x) =>
            cell === 'G' ? ({ gob: true, y, x, hp: 200, ap: 3 }) : null))
    ].filter(c => c)

    // utility functions
    const battleFinished = () => chrs.filter(c => c.elf && c.hp > 0).length < 1 || chrs.filter(c => c.gob && c.hp > 0).length < 1
    const elfAt = (x, y) => chrs.filter(e => e.elf && e.hp > 0 && e.x === x && e.y === y)[0]
    const gobAt = (x, y) => chrs.filter(g => g.gob && g.hp > 0 && g.x === x && g.y === y)[0]
    const chrAt = (x, y) => chrs.filter(c => c.hp > 0 && c.x === x && c.y === y)[0]
    const walkable = (x, y) => map[y] && map[y][x] === '.' && !chrAt(x, y)
    const adjGobs = (x, y) => [gobAt(x - 1, y), gobAt(x + 1, y), gobAt(x, y - 1), gobAt(x, y + 1)].filter(g => g)
    const adjElfs = (x, y) => [elfAt(x - 1, y), elfAt(x + 1, y), elfAt(x, y - 1), elfAt(x, y + 1)].filter(e => e)
    const adjEnemies = c => c.elf ? adjGobs(c.x, c.y) : adjElfs(c.x, c.y)
    const findEnemies = c => c.elf ? chrs.filter(e => e.gob && e.hp > 0) : chrs.filter(e => e.elf && e.hp > 0)
    const playOrder = cs => cs.sort((a, b) => a.y === b.y ? a.x - b.x : a.y - b.y)
    const neighbours = (x, y) => [[x, y - 1], [x - 1, y], [x + 1, y], [x, y + 1]]
    const sCoord = (x, y) => `${x},${y}`
    const iCoord = xy => xy.split(',').map(Number)
    const result = () => chrs.reduce((sum, c) => sum + (c.hp > 0 ? c.hp : 0), 0)

    const draw = () => {
        const d = map.map(y => y.map(x => x))
        for (const c of chrs) if (c.hp > 0) d[c.y][c.x] = c.elf ? 'E' : 'G'
        console.log(round)
        d.forEach((row, y) => {
            let line = row.join('') + '   '
            for (const c of chrs) if (c.hp > 0 && c.y === y) {
                line += c.elf ? 'E' : 'G'
                line += `(${c.hp}) `
            }
            console.log(line)
        })
    }

    let round = 0
    while (true) {
        playOrder(chrs)
        //draw(round)
        for (const curChr of chrs) {
            if (battleFinished()) return [round, result(), round * result()]
            if (curChr.hp <= 0) continue
            const adjBeforeMove = adjEnemies(curChr)
            if (adjBeforeMove.length === 0) {
                const enemies = findEnemies(curChr)
                if (enemies.length > 0) {

                    const enemyRoutes = []

                    for (const enemy of enemies) {
                        for (const adjEnemyTarget of neighbours(enemy.x, enemy.y)) {
                            if (!walkable(...adjEnemyTarget)) continue

                            // pathfind to enemy
                            const frontier = [sCoord(curChr.x, curChr.y)]
                            const path = {}
                            path[frontier[0]] = null
                            const target = sCoord(...adjEnemyTarget)

                            while (frontier.length > 0) {
                                const current = frontier.shift()
                                if (current === target) break
                                for (const next of neighbours(...iCoord(current))) {
                                    const sNext = sCoord(...next)
                                    if (sNext !== target && !walkable(...next)) continue
                                    if (sNext in path === false) {
                                        frontier.push(sNext)
                                        path[sNext] = current
                                    }
                                }
                            }

                            // get route
                            let t = target
                            const route = [t]
                            while (t) {
                                t = path[t]
                                route.unshift(t)
                            }
                            route.shift(); route.shift()
                            enemyRoutes.push(route)
                        }
                    }

                    // find closest
                    const reachable = enemyRoutes.filter(r => r.length > 0)
                    if (reachable.length > 0) {
                        reachable.sort((a, b) => a.length - b.length)
                        const dist = reachable[0].length
                        const routesAtDist = reachable.filter(e => e.length === dist)
                        const potentialTargets = routesAtDist.map(r => iCoord(r[dist - 1])).map(c => ({ x: c[0], y: c[1] }))
                        const chosenTarget = playOrder(potentialTargets)[0]
                        const targetChosen = routesAtDist.filter(e => e[dist - 1] === sCoord(chosenTarget.x, chosenTarget.y))[0]
                        curChr.x = iCoord(targetChosen[0])[0]
                        curChr.y = iCoord(targetChosen[0])[1]
                    }
                }
            }
            const adjAfterMove = adjEnemies(curChr)
            if (adjAfterMove.length > 0) {
                const weakest = Math.min(...adjAfterMove.map(e => e.hp))
                const weakestEnemies = adjAfterMove.filter(e => e.hp === weakest)
                const adjEnemy = playOrder(weakestEnemies)[0]
                adjEnemy.hp -= curChr.ap
            }
        }
        round++
    }
}

console.log(doBattle(input0), 47, 590)
console.log(doBattle(input1), 20, 937)
console.log(doBattle(input2), 37, 982)
console.log(doBattle(input3), 46, 859)
console.log(doBattle(input4), 35, 793)
console.log(doBattle(input5), 54, 536)
console.log(doBattle(input))