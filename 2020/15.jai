day15 :: (input: string) -> string, string
{ 
    while input.count
    {
        last = read_number(*input);
        seen[last] = index;
        index += 1;
    }

    seen[last] = 0;

    part1, part2 : u32;

    while index <= 30000000
    {
        when_seen := seen[last];
        next := ifx when_seen == 0 then 0 else index - when_seen - 1;
        seen[last] = index - 1;
        if index == 30000000  part2 = next;
        else if index == 2020 part1 = next;
        index += 1;
        last = next;
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

last: u32;
index: u32 = 1;
seen: [30000000]u32;

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