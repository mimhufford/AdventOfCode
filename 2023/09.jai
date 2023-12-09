day9 :: (input: string) -> string, string
{
    part1 := 0;

    while input.count
    {
        seq : [..]s64;
        for 0..20 array_add(*seq, read_s64(*input));
        part1 += calculate_next(seq);
    }

    return tprint("%", part1), tprint("%", 0);
}

#scope_file

calculate_next :: (seq : []s64) -> s64
{
    all_zeros := true;
    for seq if it != 0 { all_zeros = false; break; }
    if all_zeros return seq[seq.count-1];

    next_seq : [..]s64;
    for 0..seq.count-2 array_add(*next_seq, seq[it+1] - seq[it]);
    return seq[seq.count-1] + calculate_next(next_seq);
}