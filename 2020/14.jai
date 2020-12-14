day14 :: (input: string) -> string, string
{
    mask0, mask1, maskX, address, value : u64;
    memory1 : Table(u64, u64);
    memory2 : Table(u64, u64);
    
    while input.count
    {
        assert(input[0] == #char "m");
        advance(*input);
        if input[0] == #char "a"
        {
            mask0 = 0xFFFF_FFFF_FFFF_FFFF;
            mask1 = 0x0000_0000_0000_0000;
            maskX = 0x0000_0000_0000_0000;

            advance(*input, 6);
            for 0..35
            {
                bit := 35 - it;
                set := cast(u64)1 << bit;
                if      input[0] == #char "0" mask0 &= ~set;
                else if input[0] == #char "1" mask1 |=  set;
                else    /* input[0] == "X" */ maskX |=  set;
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

            // part 1
            modified_value := value & mask0 | mask1;
            table_set(*memory1, address, modified_value);

            // part 2
            addresses : [..]u64;
            array_add(*addresses, address | mask1);

            for 0..35
            {
                bit := cast(u64)1 << it;

                if maskX & bit
                {
                    permutations := addresses.count;
                    m0 : u64 = 0xFFFF_FFFF_FFFF_FFFF & ~bit;
                    m1 : u64 = 0x0000_0000_0000_0000 |  bit;

                    for 1..permutations
                    {
                        base := addresses[0];
                        array_ordered_remove_by_index(*addresses, 0);
                        array_add(*addresses, base & m0);
                        array_add(*addresses, base | m1);
                    }
                } 
            }

            for addresses
            {
                table_set(*memory2, it, value);
            }
        }
    }

    part1 : u64; for memory1 part1 += it;
    part2 : u64; for memory2 part2 += it;

    return tprint("%", part1), tprint("%", part2);
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