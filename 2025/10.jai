day10 :: (input: string) -> string, string
{
    part1, part2 : s64;

    machines := parse_machines(input);

    for machines {
        part1 += fewest_light_presses(it);
        // part2 += fewest_count_presses(it);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

Machine :: struct {
    light_goal : u16;
    button_masks : [..]u16;
    button_indices : [..][..]s64;
    joltages : [..]s16;
}

fewest_light_presses :: (m: Machine) -> s64 {
    // It's toggling, so we only need to press each button once
    // Go through bit combinations in increasing number of bits
    // Press any button whose bit is set, then check the result
    // e.g. for 3 buttons try 001, 010, 100, 011, 101, 110, 111
    for presses: 1..m.button_masks.count {
        x := cast(u16, 1) << presses - 1;

        while x < cast(u16, 1) << m.button_masks.count {
            lights : u16;

            for 0..m.button_masks.count-1 {
                if x & (cast(u16, 1) << it) == 0 continue;
                lights ^= m.button_masks[it];
            }

            if lights == m.light_goal return presses;

            // "gosper's hack"
            u := x & (~x + 1);
            v := x + u;
            x = v + (((v ^ x) / u) >> 2);
        }
    }

    return 0;
}

best := S64_MAX;

fewest_count_presses :: (m: Machine) -> s64 {

    internal :: (j: []s16, bs: [..][..]s64, count := 0) {
        if count >= best return;

        done := true;
        for j if it > 0 { done = false; break; }
        if done { 
            best = count;
            return;
        }

        for b: bs {
            max_presses : s16 = 999;
            for i: b max_presses = min(max_presses, j[i]);

            for < presses: 1..max_presses {
                new_j := array_copy(j);
                for i: b new_j[i] -= presses;
                internal(new_j, bs, count + presses);
            }
        }
    }

    best = S64_MAX;
    internal(m.joltages, m.button_indices);
    return best;
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
            mask := array_add(*m.button_masks);
            indices := array_add(*m.button_indices);
            while input[0] != ")" {
                index := read_u16(*input);
                mask.* |= cast(u16, 1) << index;
                array_add(indices, index);
                if input[0] == "," advance(*input);
            }
            advance(*input, 2); // skip ") "
        }

        // joltages
        advance(*input); // skip "{"
        while input[0] != "}" {
            array_add(*m.joltages, read_s16(*input));
            if input[0] == "," advance(*input);
        }
        advance(*input, 2); // skip "}\n"
    }

    return machines;
}