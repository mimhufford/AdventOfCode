day24 :: (input: string) -> string, string
{
    part1, part2 := 0;

    Group :: struct {
        units, hp, initiative : s64;
        damage, immune, weak  : [5]s64;
    }

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

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

type_to_index :: (t: string) -> s64 {
    if t == "radiation"   return 0;
    if t == "bludgeoning" return 1;
    if t == "fire"        return 2;
    if t == "slashing"    return 3;
    if t == "cold"        return 4;
    return -1;
}