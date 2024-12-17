day17 :: (input: string) -> string, string
{
    a, memory := parse_data(input);
    part1 := interpret(memory, a);
    part2 := hunt_for_quine(memory);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

parse_data :: (input: string) -> s64, []s64
{
    advance(*input, 12);
    a := read_s64(*input);
    memory : [..]s64;
    for 1..3 skip_to_next_line(*input);
    advance(*input, 9);
    
    while input
    {
        array_add(*memory, read_number(s64, *input, skip_trailing_whitespace=false));
        advance(*input);
    }

    return a, memory;
}

interpret :: (memory: []s64, a_init : s64) -> []s64
{
    ip, a, b, c := 0, a_init, 0, 0;
    result : [..]s64;

    lit_or_reg :: (v: s64) -> s64 #expand
    {
        if v <= 3 return v;
        if v == 4 return a;
        if v == 5 return b;
        if v == 6 return c;
        return 0;
    }

    while true
    {
        if ip >= memory.count break;

        if memory[ip] ==
        {
            case 0; a = a >> lit_or_reg(memory[ip+1]);
            case 1; b = b ^ memory[ip+1];
            case 2; b = lit_or_reg(memory[ip+1]) & 7;
            case 3; if a != 0 ip = memory[ip+1] - 2;
            case 4; b = b ^ c;
            case 5; array_add(*result, lit_or_reg(memory[ip+1]) & 7);
            case 6; b = a >> lit_or_reg(memory[ip+1]);
            case 7; c = a >> lit_or_reg(memory[ip+1]);
        }

        ip += 2;
    }

    return result;
}

hunt_for_quine :: (memory: []s64) -> s64
{
    queue : [..] struct { digits: s64; a_init: s64; };
    array_add(*queue, .{ 1, 0 });

    for q: queue
    {
        for a: q.a_init..q.a_init+7
        {
            result := interpret(memory, a);
            match := true;
            for i: 0..q.digits-1
            {
                if result[i] != memory[i+memory.count-q.digits]
                {
                    match = false;
                    break;
                }
            }

            if !match continue;
            if q.digits == memory.count return a;
            array_add(*queue, .{ q.digits + 1, a << 3 });
        }
    }

    return 0;
}