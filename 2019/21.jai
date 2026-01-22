day21 :: (input: string) -> string, string
{
    part1, part2 := 0;
    
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(array_copy(ram));

    in : [..]s64;
    for "NOT A J\n" array_add(*in, it);
    for "NOT J J\n" array_add(*in, it);
    for "AND B J\n" array_add(*in, it);
    for "AND C J\n" array_add(*in, it);
    for "NOT J J\n" array_add(*in, it);
    for "AND D J\n" array_add(*in, it);
    for "WALK\n"    array_add(*in, it);
    run(c, ..in);
    part1 = pop_back(*c.out);

    array_reset_keeping_memory(*in);
    for "NOT A J\n" array_add(*in, it);
    for "NOT J J\n" array_add(*in, it);
    for "AND B J\n" array_add(*in, it);
    for "AND C J\n" array_add(*in, it);
    for "NOT J J\n" array_add(*in, it);
    for "AND D J\n" array_add(*in, it);
    for "OR E T\n"  array_add(*in, it);
    for "OR H T\n"  array_add(*in, it);
    for "AND T J\n" array_add(*in, it);
    for "RUN\n"     array_add(*in, it);
    c = computer(ram);
    run(c, ..in);
    part2 = pop_back(*c.out);

    return tprint("%", part1), tprint("%", part2);
}