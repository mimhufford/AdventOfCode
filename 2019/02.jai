day2 :: (input: string) -> string, string
{
    run :: (noun: s64, verb: s64, ram: []s64) -> s64 {
        ip := 0;
        ram[1], ram[2] = noun, verb;
        while ram[ip] != 99 {
            if ram[ip] == {
                case 1; ram[ram[ip+3]] = ram[ram[ip+1]] + ram[ram[ip+2]]; ip += 4;
                case 2; ram[ram[ip+3]] = ram[ram[ip+1]] * ram[ram[ip+2]]; ip += 4;
            }
        }
        return ram[0];
    }

    ram : [..]s64;
    while input array_add(*ram, get(s64, *input));

    part1 := run(12, 2, array_copy(ram));
    part2 := 0;
    
    for < noun: 0..99 for < verb: 0..99 {
        if run(noun, verb, array_copy(ram)) != 19690720 continue;
        part2 = 100 * noun + verb;
        break noun;
    }

    return tprint("%", part1), tprint("%", part2);
}