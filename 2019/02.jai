day2 :: (input: string) -> string, string
{
    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    solve :: (noun: s64, verb: s64, c: *Computer, ram: []s64) -> s64 {
        for 0..ram.count-1 c.ram[it] = ram[it];
        c.ram[1], c.ram[2] = noun, verb;
        reset(c);
        run(c);
        return c.ram[0]; 
    }

    c := computer(array_copy(ram));
    part1 := solve(12, 2, c, ram);
    part2 := 0;
    
    for < noun: 0..99 {
        verb := 19690720 - solve(noun, 0, c, ram);
        if verb >= 0 && verb <= 99 {
            part2 = 100 * noun + verb;
            break;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}