day3 :: (input: string) -> string, string
{
    both_sum := 0;
    group_sum := 0;

    while input.count
    {
        in_group := U64_MAX;

        for 1..3
        {
            one, two := encode(read_word(*input));
            in_both  := one & two;
            both_sum += bit_scan_forward(in_both) - 1;
            in_group &= one | two;
        }

        group_sum += bit_scan_forward(in_group) - 1;
    }

    return tprint("%", both_sum), tprint("%", group_sum);
}

#scope_file

encode :: (s: string) -> u64, u64
{
    compartment_1: u64;
    compartment_2: u64;

    count := s.count / 2;

    for 0..count-1
    {
        one : u64 = (s[it]       - 38) % 58;
        two : u64 = (s[it+count] - 38) % 58;
        compartment_1 |= cast(u64)1 << one;
        compartment_2 |= cast(u64)1 << two;
    }

    return compartment_1, compartment_2;
}