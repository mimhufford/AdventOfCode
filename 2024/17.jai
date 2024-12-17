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

    lit_or_reg :: (v: s64) -> s64 #expand
    {
        if v <= 3 return v;
        if v == 4 return a;
        if v == 5 return b;
        if v == 6 return c;
        assert(false);
        return S64_MAX;
    }

    output : String_Builder;

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

    part1 := builder_to_string(*output); part1.count -= 1;
    part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}