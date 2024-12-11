day11 :: (input: string) -> string, string
{
    stones : [..]s64;
    
    while input array_add(*stones, read_s64(*input));

    for 1..25 blink(*stones);
    part1 := stones.count;
    // for 1..50 blink(*stones);
    part2 := stones.count;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

blink :: (s: *[..]s64)
{
    i := 0;

    while i < s.count
    {
        defer i += 1;

        // Rule 1
        if s.*[i] == 0
        {
            s.*[i] = 1;
            continue;
        }

        // Rule 2
        did_split, a, b := attempt_split(s.*[i]);
        if did_split
        {
            s.*[i] = a;
            array_insert_at(s, b, i+1);
            i += 1;
            continue;
        }

        // Rule 3
        s.*[i] *= 2024;
    }
}

log10 :: #run log(10.0);

attempt_split :: (n: s64) -> bool, s64, s64
{
    digits := cast(s64)(log(n*1.0) / log10) + 1;
    if digits % 2 return false, 0, 0;
    splitter := cast(s64)pow(10.0, digits*0.5);
    return true, n / splitter, n % splitter;
}