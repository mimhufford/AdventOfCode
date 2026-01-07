day9 :: (input: string) -> string, string
{
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    c := computer(ram);

    run(c, 1);
    part1 := c.out[0];

    reset(c);
    run(c, 2);
    part2 := c.out[0];

    return tprint("%", part1), tprint("%", part2);
}