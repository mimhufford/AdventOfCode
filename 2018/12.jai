day12 :: (input: string) -> string, string
{
    part1, part2 := 0;

    advance(*input, 15);
    initial := read_word(*input);

    Rule :: struct { in: string; out: u8; }
    rules : [..]Rule;

    while input {
        r := array_add(*rules);
        r.in = slice(input, 0, 5);
        advance(*input, 9);
        r.out = input[0];
        advance(*input, 2);
    }

    step :: (state: string, rules: []Rule) -> string {
        copy := tprint("..%..", state);
        next := tprint("..%..", state);

        for i: 0..copy.count-5 {
            segment := slice(copy, i, 5);
            for r: rules {
                if r.in != segment continue;
                next[i+2] = r.out;
                continue i;
            }
            next[i+2] = ".";
        }

        return next;
    }

    state := tprint("..%..", initial);
    for 1..20 state = step(state, rules);
    for state if it == "#" part1 += it_index - 42;

    return tprint("%", part1), tprint("%", part2);
}