day10 :: (input: string) -> string, string
{
    part1, part2 : s64;

    machines := parse_machines(input);

    for machines {
        part1 += fewest_light_presses(it);
        part2 += fewest_count_presses(it);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Machine :: struct {
    light_goal : u16;
    button_masks : [..]u16;
    button_indices : [..][..]s64;
    joltage : string; // TODO: part 2...
}

fewest_light_presses :: (m: Machine) -> s64 {
    seen : Table(u16, u16);
    queue : [..] struct { lights : u16; presses : u16; };
    array_add(*queue, .{});

    for i: 0..S64_MAX {
        state := queue[i];
        if state.lights == m.light_goal return state.presses;

        if table_find_pointer(*seen, state.lights) continue;
        table_add(*seen, state.lights, state.presses);

        for b: m.button_masks array_add(*queue, .{state.lights ^ b, state.presses + 1});
    }

    return 0;
}

fewest_count_presses :: (m: Machine) -> s64 {
    // TODO
    return 1;
}

parse_machines :: (input: string) -> []Machine {
    machines : [..]Machine;

    while input {
        m := array_add(*machines);

        // light indicators
        advance(*input); // skip "["
        light_goal := read_up_to(*input, "]");
        for i: 0..light_goal.count-1 {
            index := light_goal.count - i - 1;
            if light_goal[index] != "#" continue;
            m.light_goal |= cast(u16, 1) << index;
        }
        advance(*input, 2); // skip "] "

        // buttons
        while true {
            if input[0] != "(" break;
            advance(*input); // skip "("
            str := read_up_to(*input, ")");
            advance(*input, 2); // skip ") "
            mask := array_add(*m.button_masks);
            indices := array_add(*m.button_indices);
            while str {
                index := read_u16(*str);
                mask.* |= cast(u16, 1) << index;
                array_add(indices, index);
                if str advance(*str);
            }
        }

        // joltages
        advance(*input); // skip "{"
        m.joltage = read_up_to(*input, "}");
        advance(*input, 2); // skip "}\n"
    }

    return machines;
}