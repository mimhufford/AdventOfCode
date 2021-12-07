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