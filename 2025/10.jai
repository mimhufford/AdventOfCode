day10 :: (input: string) -> string, string
{
    part1, part2 : s64;

    machines : [..]Machine;

    while input {
        m := array_add(*machines);
        advance(*input); // skip "["
        light_goal := read_up_to(*input, "]");
        for i: 0..light_goal.count-1 {
            index := light_goal.count - i - 1;
            if light_goal[index] != "#" continue;
            m.light_goal |= cast(u16, 1) << index;
        }
        advance(*input, 2); // skip "] "
        while true {
            if input[0] != "(" break;
            advance(*input); // skip "("
            array_add(*m.debug_buttons, read_up_to(*input, ")"));
            advance(*input, 2); // skip ") "
            str := m.debug_buttons[m.debug_buttons.count-1];
            button := array_add(*m.buttons);
            while str {
                index := read_u16(*str);
                button.* |= cast(u16, 1) << index;
                if str advance(*str);
            }
        }
        advance(*input); // skip "{"
        m.joltage = read_up_to(*input, "}");
        advance(*input, 2); // skip "}\n"
    }

    // TODO: delete
    if false for m: machines {
        for 0..m.buttons.count-1 {
            print("% - %\n", formatInt(m.buttons[it], base=2, minimum_digits=10), m.debug_buttons[it]);
        }
    }

    for machines part1 += fewest_light_presses(it);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Machine :: struct {
    light_goal : u16;
    buttons : [..]u16;
    joltage : string; // TODO: part 2...
    debug_buttons : [..]string;  // TODO: delete
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

        for b: m.buttons array_add(*queue, .{state.lights ^ b, state.presses + 1});
    }

    return 0;
}