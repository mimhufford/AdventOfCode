day25 :: (input: string) -> string, string
{
    part1 := 0;

    advance(*input, 15);
    state := input[0] - "A";
    advance(*input, 39);
    steps := read_s64(*input);
    advance(*input, 8);

    states : [..] struct { w: [2]u8; d: [2]s8; n: [2]u8; };

    while input {
        s := array_add(*states);
        advance(*input, 63);
        s.w[0] = input[0] - "0";
        advance(*input, 30);
        s.d[0] = ifx input[0] == "r" then cast(s8, 1) else cast(s8, -1);
        read_word(*input);
        advance(*input, 22);
        s.n[0] = input[0] - "A";
        advance(*input, 54);
        s.w[1] = input[0] - "0";
        advance(*input, 30);
        s.d[1] = ifx input[0] == "r" then cast(s8, 1) else cast(s8, -1);
        read_word(*input);
        advance(*input, 22);
        s.n[1] = input[0] - "A";
        read_word(*input);
    }

    index := 5000;
    tape : [10000]u8;

    for 1..steps {
        using states[state];
        value := tape[index];
        part1 -= value;
        tape[index] = w[value];
        part1 += tape[index];
        index += d[value];
        state = n[value];
    }

    return tprint("%", part1), ":)";
}