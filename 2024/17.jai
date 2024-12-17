day17 :: (input: string) -> string, string
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
            case 0; a = a >> lit_or_reg(memory[ip+1]);
            case 1; b = b ^ memory[ip+1];
            case 2; b = lit_or_reg(memory[ip+1]) & 7;
            case 3; if a != 0 ip = memory[ip+1] - 2;
            case 4; b = b ^ c;
            case 5; append(*output, tprint("%,", lit_or_reg(memory[ip+1]) & 7));
            case 6; b = a >> lit_or_reg(memory[ip+1]);
            case 7; c = a >> lit_or_reg(memory[ip+1]);
        }

        ip += 2;
    }

    result := builder_to_string(*output);
    result.count -= 1;
    return result;
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
    //      5,5  =>  out b % 8
    //      3,0  =>  jnz 0
    //
    //  Need to work out what the algorithm is and reverse engineer it
    //
    //    while a != 0
    //      b = a % 8           take the bottom 3 bits of a
    //      b = b ^ 2           if the middle bit is on set b to 0, else 2
    //      c = a / (1 << b)    c is a if the middle bit was on, else it's a/4
    //      b = b ^ c           b is 0 or 2, so b either becomes c, or, 0 or 2
    //      b = b ^ 7           flip the last 3 bits
    //      out b % 8           check the last 3 bits
    //      a = a / 8           shift a down 3 bits
    //
    //  We get 1 output per 3 bits of a, and the required output is 16 digits
    //       0  - 2^3  - 1,  outputs 1 digit 
    //     2^ 3 - 2^6  - 1,  outputs 2 digits
    //     2^ 6 - 2^9  - 1,  outputs 3 digits
    //     2^ 9 - 2^12 - 1,  outputs 4 digits
    //     2^12 - 2^15 - 1,  outputs 5 digits
    //     2^15 - 2^18 - 1,  outputs 6 digits
    //     2^18 - 2^21 - 1,  outputs 7 digits
    //     2^21 - 2^24 - 1,  outputs 8 digits
    //     2^24 - 2^27 - 1,  outputs 9 digits
    //     2^27 - 2^30 - 1,  outputs 10 digits
    //     2^30 - 2^33 - 1,  outputs 11 digits
    //     2^33 - 2^36 - 1,  outputs 12 digits
    //     2^36 - 2^39 - 1,  outputs 13 digits
    //     2^39 - 2^42 - 1,  outputs 14 digits
    //     2^42 - 2^45 - 1,  outputs 15 digits
    //     2^45 - 2^48 - 1,  outputs 16 digits
    //  
    //  answer is between 35,184,372,088,832
    //               and 281,474,976,710,656
    //
    //  2,4,1,2,7,5,4,5,0,3,1,7,5,5,3,0
    //

    a, b, c := 0, 0, 0;
    match_index := 0;

    for a_init: 1<<45..1<<48
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