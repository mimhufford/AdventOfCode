day3 :: (input: string) -> string, string
{
    both_sum := 0;
    group_sum := 0;

    while input.count
    {
        group_contents := U64_MAX;

        for 1..3
        {
            one, two := pack(read_word(*input));
            in_both  := one & two;
            both_sum += bit_scan_forward(in_both)-1;
            group_contents &= one | two;
        }

        group_sum += bit_scan_forward(group_contents)-1;
    }

    return tprint("%", both_sum), tprint("%", group_sum);
}

pack :: (s: string) -> u64, u64
{
    compartment_1: u64;
    compartment_2: u64;

    count := s.count / 2;

    for 0..count-1
    {
        one : u64 = s[it]       - ifx s[it]       <= #char "Z" cast(u64)38 else 96;
        two : u64 = s[it+count] - ifx s[it+count] <= #char "Z" cast(u64)38 else 96;
        compartment_1 |= cast(u64)1 << one;
        compartment_2 |= cast(u64)1 << two;
    }

    return compartment_1, compartment_2;
}