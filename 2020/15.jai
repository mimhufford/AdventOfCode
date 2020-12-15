day15 :: (input: string) -> string, string
{ 
    for * seen { <<it = -1; }
    part1, part2: u32;

    while input.count { memory[index] = read_number(*input); index += 1; }

    for 0..index-2 seen[memory[it]] = xx it;

    while index < 2020 handle_last();
    part1 = memory[index - 1];

    while index < 30000000 handle_last();
    part2 = memory[index - 1];

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

index: u32;
memory: [30000000]u32;
seen:   [30000000]s32;

handle_last :: inline ()
{
    last := memory[index - 1];
    when_seen := seen[last];
    seen[last] = xx (index - 1);
    if when_seen == -1 memory[index] = 0;
    else memory[index] = xx (index - cast(s64)1 - when_seen);
    index += 1;
}

read_number :: (s: *string) -> u32
{
    num: u32;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    if s.count advance(s);

    return num;
}