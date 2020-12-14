day14 :: (input: string) -> string, string
{
    mask0, mask1, address, value : u64;
    memory : Table(u64, u64);
    
    while input.count
    {
        assert(input[0] == #char "m");
        advance(*input);
        if input[0] == #char "a"
        {
            mask0 = 0xFFFF_FFFF_FFFF_FFFF;
            mask1 = 0x0000_0000_0000_0000;

            advance(*input, 6);
            for 0..35
            {
                bit := 35 - it;
                set := cast(u64)1 << bit;
                if      input[0] == #char "0" mask0 &= ~set;
                else if input[0] == #char "1" mask1 |=  set;
                advance(*input);
            }
            advance(*input);
        }
        else
        {
            advance(*input, 3);
            address = read_number(*input);
            advance(*input, 3);
            value = read_number(*input);

            value |= mask1;
            value &= mask0;
            table_set(*memory, address, value);
        }
    }

    part1 : u64; for memory part1 += it;

    return tprint("%", part1), "";
}

#scope_file

read_number :: (s: *string) -> u64
{
    num : u64;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    if s.count advance(s);

    return num;
}