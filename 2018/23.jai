day23 :: (input: string) -> string, string
{
    part1, part2 := 0;

    bots : [..] struct { x, y, z, r: s64; };
    strongest_r, strongest_i := 0;

    while input {
        advance(*input, 5);
        b := array_add(*bots);
        b.x = read_s64(*input); advance(*input);
        b.y = read_s64(*input); advance(*input);
        b.z = read_s64(*input); advance(*input, 5);
        b.r = read_s64(*input);
        if b.r <= strongest_r continue;
        strongest_r = b.r;
        strongest_i = bots.count - 1;
    }

    strongest := bots[strongest_i];
    for bots {
        distance := abs(strongest.x - it.x) + abs(strongest.y - it.y) + abs(strongest.z - it.z);
        part1 += ifx distance <= strongest.r then 1; 
    }

    return tprint("%", part1), tprint("%", part2);
}