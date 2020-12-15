day15 :: (input: string) -> string, string
{ 
    init(*seen, 30000000);
    part1, part2: u32;

    while input.count { memory[index] = read_number(*input); index += 1; }

    for 0..index-2 table_set(*seen, memory[it], xx it);

    while index < 2020 handle_last();
    part1 = memory[index - 1];

    while index < 30000000 handle_last();
    part2 = memory[index - 1];

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

index: u32;
memory: [30000000]u32;
seen: Table(u32, u32);

handle_last :: inline ()
{
    last := memory[index - 1];
    when_seen, have_seen := table_find(seen, last);
    table_set(*seen, last, xx (index - 1));
    if have_seen memory[index] = xx (index - 1 - when_seen);
    else memory[index] = 0;
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