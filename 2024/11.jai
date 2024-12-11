day11 :: (input: string) -> string, string
{
    stones : [..]s64;
    
    while input array_add(*stones, read_s64(*input));

    for 1..25 blink(*stones);

    part1, part2 := stones.count, 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

blink :: (s: *[..]s64)
{
    i := 0;

    while i < s.count
    {
        defer i += 1;

        if s.*[i] == 0
        {
            s.*[i] = 1;
        }
        // sloooowwwwww but just getting logic right first
        else if tprint("%", s.*[i]).count % 2 == 0
        {
            t := tprint("%", s.*[i]);
            a := t; a.count /= 2;
            b := t; advance(*b, b.count / 2);
            s.*[i] = read_s64(*a);
            array_insert_at(s, read_s64(*b), i+1);
            i += 1;
        }
        else
        {
            s.*[i] *= 2024;
        }
    }
}