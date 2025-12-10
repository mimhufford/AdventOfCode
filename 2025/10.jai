day10 :: (input: string) -> string, string
{
    part1, part2 : s64;

    Machine :: struct {
        debug_goal : string;
        goal : u16;
        buttons : [..]string;
        joltage : string;
    }

    machines : [..]Machine;

    while input {
        m := array_add(*machines);
        advance(*input); // skip "["
        m.debug_goal = read_up_to(*input, "]");
        for i: 0..m.debug_goal.count-1 {
            index := m.debug_goal.count - i - 1;
            if m.debug_goal[index] != "#" continue;
            m.goal |= cast(u16, 1) << index;
        }
        advance(*input, 2); // skip "] "
        while true {
            if input[0] != "(" break;
            advance(*input); // skip "("
            array_add(*m.buttons, read_up_to(*input, ")"));
            advance(*input, 2); // skip ") "
        }
        advance(*input); // skip "{"
        m.joltage = read_up_to(*input, "}");
        advance(*input, 2); // skip "}\n"
    }

    for m: machines {
        print("% - %\n", formatInt(m.goal, base=2, minimum_digits=10), m.debug_goal);
    }

    return tprint("%", part1), tprint("%", part2);
}