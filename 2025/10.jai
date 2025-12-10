day10 :: (input: string) -> string, string
{
    part1, part2 : s64;

    Machine :: struct {
        goal : string;
        buttons : [..]string;
        joltage : string;
    }

    machines : [..]Machine;

    while input {
        m := array_add(*machines);
        advance(*input); // skip "["
        m.goal = read_up_to(*input, "]");
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

    return tprint("%", part1), tprint("%", part2);
}