day1 :: (data: string) -> string, string
{
    part1 := 0;
    part2 := 0;

    a := next_u32(*data);
    b := next_u32(*data);
    c := next_u32(*data);

    if b > a  part1 += 1;
    if c > b  part1 += 1;

    while data.count
    {
        d := next_u32(*data);

        prev := a + b + c;
        curr := b + c + d;

        if    d > c     part1 += 1;
        if curr > prev  part2 += 1;

        a = b;
        b = c;
        c = d;
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