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

Button :: struct {
    mask: u16;
    indices: [..]s64;
}

Machine :: struct {
    light_goal : u16;
    buttons : [..]Button;
    joltages : [..]s16;
}

fewest_light_presses :: (m: Machine) -> s64 {
    // It's toggling, so we only need to press each button once
    // Go through bit combinations in increasing number of bits
    // Press any button whose bit is set, then check the result
    // e.g. for 3 buttons try 001, 010, 100, 011, 101, 110, 111
    for presses: 1..m.buttons.count {
        x := cast(u16, 1) << presses - 1;

        while x < cast(u16, 1) << m.buttons.count {
            lights : u16;

            for 0..m.buttons.count-1 {
                if x & (cast(u16, 1) << it) == 0 continue;
                lights ^= m.buttons[it].mask;
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

fewest_count_presses :: (m: Machine) -> s64 {

    inner :: (m: Machine, joltages: []s16, cache: *Table(string, s64)) -> s64 {
        key := tprint("%", joltages);
        cached_result := table_find_pointer(cache, key);
        if cached_result return cached_result.*;

        done := true;
        for joltages if it { done = false; break; }
        if done return 0;

        goal : u16;
        for joltage, index: joltages {
            if joltage % 2 == 0 continue;
            goal |= cast(u16, 1) << index;
        }

        combinations := 1 << m.buttons.count;

        best := S64_MAX;

        for press_mask: 0..combinations-1 {
            parity : u16;

            for index: 0..m.buttons.count-1 {
                if press_mask & (1 << index) == 0 continue;
                parity ^= m.buttons[index].mask;
            }

            if goal != parity continue;

            new_joltages := array_copy(joltages);

            for index: 0..m.buttons.count-1 {
                if press_mask & (1 << index) == 0 continue;
                for m.buttons[index].indices {
                    new_joltages[it] -= 1;
                    if new_joltages[it] < 0 continue press_mask;
                }
            }

            for * new_joltages it.* /= 2;

            best = min(best, popcount(press_mask) + 2 * inner(m, new_joltages, cache));
        }

        table_add(cache, key, best);
        return best;
    }

    cache : Table(string, s64);
    result := inner(m, m.joltages, *cache);
    deinit(*cache);
    return result;
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
            button := array_add(*m.buttons);
            while input[0] != ")" {
                index := read_u16(*input);
                button.mask |= cast(u16, 1) << index;
                array_add(*button.indices, index);
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