const input = require("./data").day24.split('-')
const input0 = `17 units each with 5390 hit points (weak to radiation, bludgeoning) with an attack that does 4507 fire damage at initiative 2
989 units each with 1274 hit points (immune to fire; weak to bludgeoning, slashing) with an attack that does 25 slashing damage at initiative 3
-
801 units each with 4706 hit points (weak to radiation) with an attack that does 116 bludgeoning damage at initiative 1
4485 units each with 2961 hit points (immune to radiation; weak to fire, cold) with an attack that does 12 slashing damage at initiative 4`.split('-')

const parse = team => {
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
        ap: nums[i][2],
        type: type[i],
        init: nums[i][3],
        nextAttack: null,
        nextDefend: null,
    }))
}

const groups = [...parse(0), ...parse(1)]

while (true) {
    // 
    // CHOOSE TARGETS
    // 
    // phase 1: order by >ep, >initiative
    const chooseOrder = groups.filter(g => g.units).sort((a, b) => {
        a.nextDefend = b.nextDefend = a.nextAttack = b.nextAttack = null
        a.ep = a.units * a.ap
        b.ep = b.units * b.ap
        return a.ep == b.ep ? b.init - a.init : b.ep - a.ep
    })
    // phase 2: pick available target which would take the most damage
    //          break ties using >ep, >initiative
    //          if no damage possible don't pick a group
    for (const cur of chooseOrder) {
        const targets = groups.filter(g => g.units && g.team != cur.team && g.nextDefend == null)
        for (const t of targets)
            t.dmg = t.immune.includes(cur.type) ? 0 : t.weak.includes(cur.type) ? cur.ep * 2 : cur.ep
        const t = targets.sort((a, b) =>
            a.dmg == b.dmg ? a.ep == b.ep ? b.init - a.init : b.ep - a.ep : b.dmg - a.dmg
        )[0]
        if (t && t.dmg) {
            cur.nextAttack = t
            t.nextDefend = cur
            console.log(`${cur.team ? 'infect' : 'immune'}:${cur.group} would deal ${t.group} ${t.dmg} damage`)
        }
    }

    //
    // ATTACK
    //
    // phase 1: order by >initiative
    const attackOrder = groups.filter(g => g.units).sort((a, b) => b.init - a.init)
    // phase 2: do attack
    for (const cur of attackOrder) {
        if (!cur.units || !cur.nextAttack) continue
        cur.ep = cur.units * cur.ap
        const t = cur.nextAttack
        t.dmg = t.immune.includes(cur.type) ? 0 : t.weak.includes(cur.type) ? cur.ep * 2 : cur.ep
        const unitsKilled = Math.min(Math.floor(t.dmg / t.hp), t.units)
        t.units -= unitsKilled
        console.log(`${cur.team ? 'infect' : 'immune'}:${cur.group} kills ${unitsKilled} from ${t.group}`)
    }

    //
    // CHECK FOR VICTORY
    //
    const immune = groups.filter(g => g.team == 0 && g.units)
    const infect = groups.filter(g => g.team == 1 && g.units)

    if (immune.length == 0) {
        console.log(infect.map(i => i.units).reduce((r, c) => r + c, 0))
        break
    }
    else if (infect.length == 0) {
        console.log(immune.map(i => i.units).reduce((r, c) => r + c, 0))
        break
    }
}