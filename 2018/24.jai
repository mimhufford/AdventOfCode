day24 :: (input: string) -> string, string
{
    part1, part2 := 0;

    t1, t2 := generate_teams(input);

    part1 = do_battle(t1, t2);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Group :: struct {
    units, hp, initiative : s64;
    damage, immune, weak  : [5]s64; // TODO: split damage into damage s64 and damage type s64
    
    effective_power : s64;
    target : *Group;
    target_damage : s64;
    targetted : bool;
}

do_battle :: (_t1: []Group, _t2: []Group, boost := 0) -> s64, bool {
    t1 : [..]Group; array_add(*t1, .._t1);
    t2 : [..]Group; array_add(*t2, .._t2);
    for * t1 for *it.damage if it.* then it.* += boost;

    all : [..]*Group;
    for * t1 array_add(*all, it);
    for * t2 array_add(*all, it);
    quick_sort(all, g => -g.initiative);

    while true {
        // PHASE 1: Select Targets
        update_effective_power(t1);
        update_effective_power(t2);
        quick_sort(t1, sort_ep_initiative);
        quick_sort(t2, sort_ep_initiative);
        select_targets(t1, t2);
        select_targets(t2, t1);

        // PHASE 2: Attack
        for g: all {
            if g.target == null continue;
            if g.units <= 0 continue;
            g.target.units -= g.target_damage / g.target.hp;
        }

        t1_units, t2_units := 0;
        for t1 t1_units += it.units;
        for t2 t2_units += it.units;
        if t1_units <= 0 return t2_units, false;
        if t2_units <= 0 return t1_units, true;
    }

    return 0, false;
}

update_effective_power :: (t: []Group) {
    for * g: t {
        g.effective_power = 0;
        for g.damage g.effective_power += g.units * it;
    }
}

calculate_damage :: (a: *Group, d: *Group) -> s64 {
    for 0..4 if a.damage[it] && d.immune[it] return 0;
    for 0..4 if a.damage[it] && d.weak[it]   return a.effective_power * 2;
    return a.effective_power;
}

select_targets :: (t1: []Group, t2: []Group) {
    for * t1 { it.target = null; it.target_damage = 0; }
    for * t2 { it.targetted = false; }

    for * g: t1 {
        if g.units <= 0 continue;
        for * e: t2 {
            if e.targetted  continue;
            if e.units <= 0 continue;
            potential_damage := calculate_damage(g, e);
            if potential_damage <= g.target_damage continue;
            if g.target g.target.targetted = false;
            g.target = e;
            g.target_damage = potential_damage;
            e.targetted = true;
        }
    }
}

sort_ep_initiative :: (a: Group, b: Group) -> s64 {
    if a.effective_power > b.effective_power return -1;
    if a.effective_power < b.effective_power return +1;
    if a.initiative > b.initiative return -1;
    if a.initiative < b.initiative return +1;
    return 0;
}

type_to_index :: (t: string) -> s64 {
    if t == "radiation"   return 0;
    if t == "bludgeoning" return 1;
    if t == "fire"        return 2;
    if t == "slashing"    return 3;
    if t == "cold"        return 4;
    return -1;
}

generate_teams :: (input: string) -> []Group, []Group {
    t1, t2 : [..]Group;

    for team_info, team_id: split(trim(input), "\n\n") {
        for line: split(team_info, "\n") {
            if line[0] == "I" continue;

            g := array_add(ifx team_id == 0 then *t1 else *t2);
            g.units = read_s64(*line); advance(*line, 16);
            g.hp    = read_s64(*line); advance(*line, 11);

            if line[0] == "(" {
                modifiers := read_up_to(*line, ")");
                advance(*modifiers);
                for split(modifiers, ";") {
                    section := trim(it);
                    modifier := read_word(*section);
                    advance(*section, 3);
                    for type: split(section, ", ") {
                        if modifier == "immune" g.immune[type_to_index(type)] = 1;
                        if modifier == "weak"     g.weak[type_to_index(type)] = 1;
                    }
                }
                advance(*line, 2);
            }

            advance(*line, 25);
            damage := read_s64(*line);
            g.damage[type_to_index(read_word(*line))] = damage;
            advance(*line, 21);
            g.initiative = read_s64(*line);
        }
    }

    return t1, t2;
}