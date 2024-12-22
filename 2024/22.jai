day22 :: (input: string) -> string, string
{
    part1, part2 := 0;

    while input
    {
        seed := read_s64(*input);
        res := generate(seed, 2000);
        part1 += res;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

generate :: (s: s64, times: s64) -> s64
{
    r := s;

    for 1..times
    {
        r ^= r * 64;
        r %= 16777216;
        r ^= r / 32;
        r %= 16777216;
        r ^= r * 2048;
        r %= 16777216;
    }

    return r;
}