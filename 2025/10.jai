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

best := S64_MAX;

fewest_count_presses :: (m: Machine) -> s64 {

    internal :: (j: []s16, bs: [..]Button, count := 0) {
        if count >= best return;

        done := true;
        for j if it > 0 { done = false; break; }
        if done { 
            best = count;
            return;
        }

        // press buttons that reduce the least referenced remaining joltage first
        references : [16]s8;
        for b: bs { for i: b.indices { references[i] += 1; } }
            
        least_value := 999;
        least_index := 999;
        for references {
            if it && it < least_value && j[it_index] {
                least_index = it_index;
                least_value = it;
            }
        }
    
        // TODO: make this into a bit mask to avoid creating new arrays
        press_now : [..]Button;
        press_later : [..]Button;

        for b: bs {
            target := ifx array_find(b.indices, least_index) then *press_now else *press_later;
            array_add(target, b);
        }

        // print("%\n", j);
        // print("%\n", least_index);
        // print("%\n", press_now);
        // print("%\n", press_later);
        // print("======\n");

        // TODO: work out combinations of button presses for press_now
        //       for each combo:
        //           press so that joltage is now 0 (without making others negative)
        //           recurse with new joltages and press_later buttons      
        for b: press_now {
            max_presses : s16 = 999;
            for i: b.indices max_presses = min(max_presses, j[i]);

            for < presses: 1..max_presses {
                new_j := array_copy(j);
                for i: b.indices new_j[i] -= presses;
                internal(new_j, press_later, count + presses);
            }
        }
    }

    best = S64_MAX;
    internal(m.joltages, m.buttons);
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