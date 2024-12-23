day23 :: (input: string) -> string, string
{
    connections : [26*26] [..]s64;

    while input
    {
        a := input; a.count = 2; advance(*input, 3);
        b := input; b.count = 2; advance(*input, 3);

        ai, bi := get_id(a), get_id(b);
        
        array_add_if_unique(*connections[ai], bi);
        array_add_if_unique(*connections[bi], ai);
    }

    for * connections
    {
        if it.count == 0 continue;
        print("%: ", cast(string)get_str(it_index));
        for it.* print("% ", cast(string)get_str(it));
        print("\n");
    }

    part1, part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

get_id :: (computer: string) -> s64
{
    return cast(s64)(computer[0] - #char "a") * 26 + cast(s64)(computer[1] - #char "a");
}

get_str :: (id: s64) -> [2]u8
{
    computer : [2]u8;
    computer[0] = cast(u8)(id / 26) + #char "a";
    computer[1] = cast(u8)(id % 26) + #char "a";
    return computer;
}