day17 :: (input: string) -> string, string
{
    advance(*input, 12);  a := read_s64(*input);
    advance(*input, 12);  b := read_s64(*input);
    advance(*input, 12);  c := read_s64(*input);
    advance(*input, 9);  ip := 0;
    memory : [..]s64;
    
    while input
    {
        array_add(*memory, read_number(s64, *input, skip_trailing_whitespace=false));
        advance(*input);
    }

    part1 := interpret(memory, a);
    part2 := quine_hand_compiled(memory);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

interpret :: (memory: []s64, a_init : s64) -> string
{
    ip, a, b, c := 0, a_init, 0, 0;
    output : String_Builder;

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
            case 0; a = a / (1 << lit_or_reg(memory[ip+1]));
            case 1; b = b ^ memory[ip+1];
            case 2; b = lit_or_reg(memory[ip+1]) % 8;
            case 3; if a != 0 ip = memory[ip+1] - 2;
            case 4; b = b ^ c;
            case 5; append(*output, tprint("%,", lit_or_reg(memory[ip+1]) % 8));
            case 6; b = a / (1 << lit_or_reg(memory[ip+1]));
            case 7; c = a / (1 << lit_or_reg(memory[ip+1]));
        }

        ip += 2;
    }

    result := builder_to_string(*output);
    result.count -= 1;
    return result;
}

quine_interpretted :: (memory: []s64) -> s64
{
    for a_init: 0..S64_MAX
    {
        ip, a, b, c, match_index := 0, a_init, 0, 0, 0;

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
            if ip >= memory.count
            {
                if match_index == memory.count return a_init;
                continue a_init;
            }

            if memory[ip] ==
            {
                case 0; a = a / (1 << lit_or_reg(memory[ip+1]));
                case 1; b = b ^ memory[ip+1];
                case 2; b = lit_or_reg(memory[ip+1]) % 8;
                case 3; if a != 0 ip = memory[ip+1] - 2;
                case 4; b = b ^ c;
                case 6; b = a / (1 << lit_or_reg(memory[ip+1]));
                case 7; c = a / (1 << lit_or_reg(memory[ip+1]));
                case 5;
                {
                    value := lit_or_reg(memory[ip+1]) % 8;
                    if value != memory[match_index] continue a_init;
                    match_index += 1;
                }
            }

            ip += 2;
        }
    }

    return 0;
}

quine_hand_compiled :: (memory: []s64) -> s64
{
    //  Compiling my input by hand gives this:
    //      2,4  =>  b = a % 8
    //      1,2  =>  b = b ^ 2
    //      7,5  =>  c = a / (1 << b)
    //      4,5  =>  b = b ^ c
    //      0,3  =>  a = a / 8
    //      1,7  =>  b = b ^ 7
    //      5,5  =>  out b%8
    //      3,0  =>  jnz 0
    //
    //  Need to work out what the algorithm is and reverse it
    //
    //    b = a % 8           take the bottom 3 bits of a
    //    b = b ^ 2           if the middle bit is on set b to 0, else 2
    //    c = a / (1 << b)    c is a if the middle bit was on, else it's a/4
    //    b = b ^ c           b is 0 or 2, so b either becomes c, or, 0 or 2
    //    a = a / 8           shift a down 3 bits
    //    b = b ^ 7
    //    out b%8
    //    jnz 0
    //

    a, b, c := 0, 0, 0;
    match_index := 0;

    for a_init: 194500000000..S64_MAX
    {
        if a_init % 100_000_000 == 0 print("%\n", a_init);

        ip, a, b, c, match_index := 0, a_init, 0, 0, 0;

        while a != 0
        {
            b = a % 8;
            b = b ^ 2;
            c = a / (1 << b);
            b = b ^ c;
            a = a / 8;
            b = b ^ 7;
            if b%8 != memory[match_index] continue a_init;
            match_index += 1;
        }

        if match_index == memory.count return a_init;
    }

    return 0;
}