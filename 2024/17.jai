day17 :: (input: string) -> string, string
{
    a, rom := parse_data(input);
    part1 := interpret(rom, a);
    part2 := hunt_for_quine(rom);

    return tprint("%", make_nice_part_1_output(part1)), tprint("%", part2);
}

#scope_file

parse_data :: (input: string) -> s64, []s64
{
    advance(*input, 12);
    a := read_s64(*input);
    rom : [..]s64;
    for 1..3 skip_to_next_line(*input);
    advance(*input, 9);
    
    while input
    {
        array_add(*rom, read_number(s64, *input, skip_trailing_whitespace=false));
        advance(*input);
    }

    return a, rom;
}

interpret :: (rom: []s64, a_init : s64) -> []s64
{
    ip, a, b, c := 0, a_init, 0, 0;
    out : [..]s64;

    lit_or_reg :: (v: s64) -> s64 #expand
    {
        if v == {
            case 4; return a;
            case 5; return b;
            case 6; return c;
            case;   return v;
        }
    }

    while ip < rom.count
    {
        if rom[ip] ==
        {
            case 0; a = a >> lit_or_reg(rom[ip+1]);
            case 1; b = b ^ rom[ip+1];
            case 2; b = lit_or_reg(rom[ip+1]) & 7;
            case 3; if a != 0 ip = rom[ip+1] - 2;
            case 4; b = b ^ c;
            case 5; array_add(*out, lit_or_reg(rom[ip+1]) & 7);
            case 6; b = a >> lit_or_reg(rom[ip+1]);
            case 7; c = a >> lit_or_reg(rom[ip+1]);
        }

        ip += 2;
    }

    return out;
}

hunt_for_quine :: (rom: []s64) -> s64
{
    queue : [..] struct { digits: s64; a_init: s64; };
    array_add(*queue, .{ 1, 0 });

    for q: queue
    {
        for a: q.a_init..q.a_init+7
        {
            out := interpret(rom, a);
            for i: 0..q.digits-1 if out[i] != rom[i+rom.count-q.digits] continue a;
            if q.digits == rom.count return a;
            array_add(*queue, .{ q.digits + 1, a << 3 });
        }
    }

    return 0;
}

make_nice_part_1_output :: (out: []s64) -> s64
{
    // I don't want a load of commas in my output thank you very much :)
    result := 0;
    for out { result *= 10; result += it; }
    return result;
}