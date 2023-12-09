day9 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input.count
    {
        seq : [..]s64;
        for 0..20 array_add(*seq, read_s64(*input));
        part1 += calculate_next(seq);
        for 0..9 seq[it], seq[20-it] = seq[20-it], seq[it];
        part2 += calculate_next(seq);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

calculate_next :: (seq : []s64) -> s64
{
    all_zeros := true;
    for seq if it != 0 { all_zeros = false; break; }
    if all_zeros return 0;

    next_seq : [..]s64;
    for 0..seq.count-2 array_add(*next_seq, seq[it+1] - seq[it]);
    return seq[seq.count-1] + calculate_next(next_seq);
}