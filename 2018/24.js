const input0 = require("./data").day24.split('-')
const input = `17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3
-
801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4`.split('-')

const parse = (team, boost = 0) => {
    const data = input[team].trim().split('\n')
    const nums = data.map(g => g.match(/\d+/g).map(Number))
    const imms = data.map(g => g.match(/immune to (.+?)[;|)]/)).map(i => i ? i[1].split(',') : [])
    const weak = data.map(g => g.match(/weak to (.+?)[;|)]/)).map(i => i ? i[1].split(', ') : [])
    const type = data.map(g => g.match(/attack that does \d+ (.+) damage/)[1])
    return nums.map((_, i) => ({
        team,
        group: i + 1,
        units: nums[i][0],
        hp: nums[i][1],
        immune: imms[i],
        weak: weak[i],
        ap: nums[i][2] + boost,
        type: type[i],
        init: nums[i][3],
        nextAttack: null,
        nextDefend: null,
    }))
}

const battle = groups => {
    while (true) {
        // 
        // CHOOSE TARGETS
        // 
        // phase 1: order by >ep, >initiative
        const chooseOrder = groups.filter(g => g.units > 0).sort((a, b) => {
            a.nextDefend = b.nextDefend = a.nextAttack = b.nextAttack = null
            a.ep = a.units * a.ap
            b.ep = b.units * b.ap
            return a.ep == b.ep ? b.init - a.init : b.ep - a.ep
        })
        // phase 2: pick available target which would take the most damage
        //          break ties using >ep, >initiative
        //          if no damage possible don't pick a group
        for (const cur of chooseOrder) {
            const targets = groups.filter(g => g.units > 0 && g.team != cur.team && g.nextDefend == null)
            for (const t of targets)
                t.dmg = t.immune.includes(cur.type) ? 0 : cur.ep * (t.weak.includes(cur.type) ? 2 : 1)
            const t = targets.sort((a, b) =>
                a.dmg == b.dmg ? a.ep == b.ep ? b.init - a.init : b.ep - a.ep : b.dmg - a.dmg
            )[0]
            if (t && t.dmg) {
                cur.nextAttack = t
                t.nextDefend = cur
            }
        }

        //
        // ATTACK
        //
        // phase 1: order by >initiative
        const attackOrder = groups.filter(g => g.units > 0).sort((a, b) => b.init - a.init)
        // phase 2: do attack
        for (const cur of attackOrder) {
            if (!cur.nextAttack) continue
            cur.ep = cur.units * cur.ap
            const t = cur.nextAttack
            t.dmg = t.immune.includes(cur.type) ? 0 : cur.ep * (t.weak.includes(cur.type) ? 2 : 1)
            const unitsKilled = Math.floor(t.dmg / t.hp)
            t.units -= unitsKilled
        }

        //
        // CHECK FOR VICTORY
        //
        const immune = groups.filter(g => g.team == 0 && g.units > 0)
        const infect = groups.filter(g => g.team == 1 && g.units > 0)

        if (immune.length == 0)
            return [1, infect.map(i => i.units).reduce((r, c) => r + c, 0)]
        if (infect.length == 0)
            return [0, immune.map(i => i.units).reduce((r, c) => r + c, 0)]
    }
}

console.log("Part 1:", battle([...parse(0), ...parse(1)])[1])

for (let boost = 1; true; boost++) {
    const result = battle([...parse(0, boost), ...parse(1)])
    if (result[0] == 0) {
        console.log("Part 2:", result[1])
        return
    }
}