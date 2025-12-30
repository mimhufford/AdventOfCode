day25 :: (input: string) -> string, string
{
    part1 := 0;

    advance(*input, 15);
    state := input[0] - "A";
    advance(*input, 39);
    steps := read_s64(*input);
    advance(*input, 8);

    State :: struct {
        w0, w1 : u8;
        d0, d1 : s8;
        n0, n1 : u8;
    }

    states : [..]State;

    while input {
        s := array_add(*states);
        advance(*input, 63);
        s.w0 = input[0] - "0";
        advance(*input, 30);
        s.d0 = ifx input[0] == "r" then cast(s8, 1) else cast(s8, -1);
        read_word(*input);
        advance(*input, 22);
        s.n0 = input[0] - "A";
        advance(*input, 54);
        s.w1 = input[0] - "0";
        advance(*input, 30);
        s.d1 = ifx input[0] == "r" then cast(s8, 1) else cast(s8, -1);
        read_word(*input);
        advance(*input, 22);
        s.n1 = input[0] - "A";
        read_word(*input);
    }

    index := 5000;
    tape : [10000]u8;

    for 1..steps {
        using states[state];
        if tape[index] {
            tape[index] = w1;
            index += d1;
            state = n1;
        } else {
            tape[index] = w0;
            index += d0;
            state = n0;
        }
    }

    for tape part1 += it;

    return tprint("%", part1), ":)";
}