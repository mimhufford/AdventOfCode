day1 :: (input: string) -> string, string
{
    part1, part2 := 0;

    frequency := 0;
    changes : [..]s64;
    seen : Table(s64, s8);

    while input {
        if input[0] == "+" advance(*input);
        array_add(*changes, read_s64(*input));
        frequency += changes[changes.count-1];
        find_or_add(*seen, frequency).* += 1;
    }

    part1 = frequency;

    for iteration: 0..S64_MAX {
        for changes {
            frequency += it;
            entry := find_or_add(*seen, frequency);
            entry.* += 1;
            if entry.* < 2 continue;
            part2 = frequency;
            break iteration;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}