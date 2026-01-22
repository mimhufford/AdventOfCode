day5 :: (input: string) -> string, string
{
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    c1 := computer(array_copy(ram));
    run(c1, 1);
    part1 := pop_back(*c1.out);

    c2 := computer(array_copy(ram));
    run(c2, 5);
    part2 := pop_back(*c2.out);

    return tprint("%", part1), tprint("%", part2);
}