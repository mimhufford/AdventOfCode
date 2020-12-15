day15 :: (input: string) -> string, string
{
    memory: [..]int;       array_reserve(*memory, 30000000);
    seen: Table(int, int); init(*seen, 30000000);
    part1, part2: int;

    while input.count array_add(*memory, read_number(*input));

    for 0..memory.count-2 table_set(*seen, memory[it], xx it);

    while memory.count < 2020 handle_last(*memory, seen);
    part1 = memory[memory.count - 1];

    while memory.count < 30000000 handle_last(*memory, seen);
    part2 = memory[memory.count - 1];

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

handle_last :: inline (memory: *[..]int, seen: Table)
{
    last := memory.data[memory.count - 1];
    when_seen, have_seen := table_find(seen, last);
    table_set(*seen, last, memory.count - 1);
    if have_seen array_add(memory, memory.count - 1 - when_seen);
    else array_add(memory, 0);
}

read_number :: (s: *string) -> int
{
    num: int;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s);
    }

    if s.count advance(s);

    return num;
}