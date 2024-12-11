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

}