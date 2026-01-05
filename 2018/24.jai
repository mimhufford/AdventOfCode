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
    damage, immune, weak  : [5]s64;
}

do_battle :: (_t1: []Group, _t2: []Group, boost := 0) -> s64, bool {
    t1 : [..]Group; array_add(*t1, .._t1);
    t2 : [..]Group; array_add(*t2, .._t2);

    for * t1 for *it.damage if it.* then it.* += boost;

    // TODO
    print("%\n%\n", t1, t2);

    t1_units, t2_units := 0;
    for t1 t1_units += it.units;
    for t2 t2_units += it.units;
    return max(t1_units, t2_units), t1_units > t2_units;
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