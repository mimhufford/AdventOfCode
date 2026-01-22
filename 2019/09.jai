day9 :: (input: string) -> string, string
{
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    c := computer(ram);

    run(c, 1);
    part1 := pop_back(*c.out);

    reset(c);
    run(c, 2);
    part2 := pop_back(*c.out);

    return tprint("%", part1), tprint("%", part2);
}