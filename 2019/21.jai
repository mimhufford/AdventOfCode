day21 :: (input: string) -> string, string
{
    part1, part2 := 0;
    
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));
    c := computer(array_copy(ram));

    in : [..]s64;
    for < "NOT A J\nNOT J J\nAND B J\nAND C J\nNOT J J\nAND D J\nWALK\n" { array_add(*in, it); }
    run(c, ..in);
    part1 = peek(c.out);

    array_reset_keeping_memory(*in);
    for < "NOT A J\nNOT J J\nAND B J\nAND C J\nNOT J J\nAND D J\nOR E T\nOR H T\nAND T J\nRUN\n" { array_add(*in, it); }
    c = computer(ram);
    run(c, ..in);
    part2 = peek(c.out);

    return tprint("%", part1), tprint("%", part2);
}