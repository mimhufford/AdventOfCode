day24 :: (input: string) -> string, string
{
    part1, part2 := 0;

    t1, t2 := generate_teams(input);

    part1 = do_battle(t1, t2);

    l, r := 1, 1000;
    while l + 1 < r {
        m := l + (r - l) / 2;
        units, win := do_battle(t1, t2, m);
        if !win { l = m; } else { r = m; part2 = units; } 
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Group :: struct {
    units, hp, initiative : s64;
    damage, damage_type : s64;
    immune, weak  : [5]s64;
    
    effective_power : s64;
    target : *Group;
    targetted : bool;
}

do_battle :: (_t1: []Group, _t2: []Group, boost := 0) -> s64, bool {
    __t1 : [..]Group; array_add(*__t1, .._t1);
    __t2 : [..]Group; array_add(*__t2, .._t2);
    t1 : [..]*Group; for * __t1 array_add(*t1, it);
    t2 : [..]*Group; for * __t2 array_add(*t2, it);
    for t1 it.damage += boost;

    all : [..]*Group;
    for t1 array_add(*all, it);
    for t2 array_add(*all, it);
    quick_sort(all, g => -g.initiative);

    while true {
        any_change := false;

        // PHASE 1: Select Targets
        for t1 it.effective_power = it.damage * it.units;
        for t2 it.effective_power = it.damage * it.units;
        quick_sort(t1, sort_ep_initiative);
        quick_sort(t2, sort_ep_initiative);
        select_targets(t1, t2);
        select_targets(t2, t1);

        // PHASE 2: Attack
        for g: all {
            if g.target == null continue;
            if g.units <= 0 continue;
            g.effective_power = g.damage * g.units;
            units_before_attack := g.target.units;
            g.target.units -= calculate_damage(g, g.target) / g.target.hp;
            any_change |= g.target.units != units_before_attack;
        }

        t1_units, t2_units := 0;
        for t1 { if it.units <= 0 remove it; else t1_units += it.units; }
        for t2 { if it.units <= 0 remove it; else t2_units += it.units; }
        if t1_units <= 0 return t2_units, false;
        if t2_units <= 0 return t1_units, true;
        if !any_change return 0, false;
    }

    return 0, false;
}

calculate_damage :: (a: *Group, d: *Group) -> s64 {
    if d.immune[a.damage_type] return 0;
    if d.weak[a.damage_type] return a.effective_power * 2;
    return a.effective_power;
}

select_targets :: (t1: []*Group, t2: []*Group) {
    for t1 it.target = null;
    for t2 it.targetted = false;

    for g: t1 {
        if g.units <= 0 continue;

        best_target : *Group;
        best_damage, best_ep, best_initiative : s64;

        for e: t2 {
            if e.targetted  continue;
            if e.units <= 0 continue;
            potential_damage := calculate_damage(g, e);
            if potential_damage < best_damage continue;
            if potential_damage == best_damage && e.effective_power < best_ep continue;
            if potential_damage == best_damage && e.effective_power == best_ep && e.initiative < best_initiative continue;
            best_target = e;
            best_damage = potential_damage;
            best_ep = e.effective_power;
            best_initiative = e.initiative;
        }

        if best_target && best_damage {
            g.target = best_target;
            g.target.targetted = true;
        }
    }
}

sort_ep_initiative :: (a: *Group, b: *Group) -> s64 {
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
            g.damage = read_s64(*line);
            g.damage_type = type_to_index(read_word(*line));
            advance(*line, 21);
            g.initiative = read_s64(*line);
        }
    }

    return t1, t2;
}