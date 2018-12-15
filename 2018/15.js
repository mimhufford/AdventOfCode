const input = require("./data").day15.split('\n').map(line => line.split(''))

const doBattle = (startingGrid, elfPower) => {
    const map = startingGrid.map(cells => cells.map(cell => cell === '#' ? '#' : '.'))
    const chrs = [
        ...startingGrid.flatMap((cells, y) => cells.map((cell, x) =>
            cell === 'E' ? ({ elf: true, y, x, hp: 200, ap: elfPower }) : null)),
        ...startingGrid.flatMap((cells, y) => cells.map((cell, x) =>
            cell === 'G' ? ({ gob: true, y, x, hp: 200, ap: 3 }) : null))
    ].filter(c => c)

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
    const numElves = () => chrs.filter(c => c.elf && c.hp > 0).length

    const numStartingElves = numElves()

    for (let round = 0; true; round++) {
        playOrder(chrs)
        for (const curChr of chrs) {
            if (battleFinished()) return [round * result(), numStartingElves === numElves()]
            if (curChr.hp <= 0) continue
            const adjBeforeMove = adjEnemies(curChr)
            if (adjBeforeMove.length === 0) {
                const enemies = findEnemies(curChr)
                if (enemies.length > 0) {
                    const enemyRoutes = []
                    for (const enemy of enemies) {
                        for (const adjEnemyTarget of neighbours(enemy.x, enemy.y)) {
                            if (!walkable(...adjEnemyTarget)) continue
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
                if (adjEnemy.ap > 3 && adjEnemy.hp < 1) return [0, false]                
            }
        }
    }
}

console.log("Part 1:", doBattle(input, 3)[0])

for (let ap = 4; true; ap++) {
    const outcome = doBattle(input, ap)
    if (outcome[1]) {
        console.log("Part 2:", outcome[0])
        break
    }
}