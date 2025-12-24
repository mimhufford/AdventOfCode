day5 :: (input: string) -> string, string
{
    part1, part2 := 0;

    memory1, memory2 : [..]s64;

    while input {
        value := read_s64(*input);
        array_add(*memory1, value);
        array_add(*memory2, value);
    }

    count :: (memory: []s64, offset: (s64) -> s64) -> s64 {
        steps, index : s64;
        while index >= 0 && index < memory.count {
            next := index + memory[index];
            memory[index] += offset(memory[index]);
            index = next;
            steps += 1;
        }
        return steps;
    }

    part1 = count(memory1, n => 1);
    part2 = count(memory2, n => ifx n >= 3 then -1 else 1);

    return tprint("%", part1), tprint("%", part2);
}