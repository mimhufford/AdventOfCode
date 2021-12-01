day1 :: (data: string) -> string, string
{
    part1, part2 : u32;

    a := next_u32(*data);
    b := next_u32(*data);
    c := next_u32(*data);

    if b > a  part1 += 1;
    if c > b  part1 += 1;

    while data.count
    {
        d := next_u32(*data);

        if d > c  part1 += 1;
        if d > a  part2 += 1;

        a, b, c = b, c, d;
    }

    return tprint("%", part1), tprint("%", part2);
}

next_u32 :: (s: *string) -> u32
{
    num : u32;

    while s.count && s.data[0] >= #char "0" && s.data[0] <= #char "9"
    {
        num *= 10;
        num += s.data[0] - #char "0";
        advance(s, 1);
    }

    while s.count && (s.data[0] < #char "0" || s.data[0] > #char "9") advance(s, 1);

    return num;
}