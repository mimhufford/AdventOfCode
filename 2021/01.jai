day1 :: (data: string) -> string, string
{
    part1, part2 : u32;

    a := get(u32, *data);
    b := get(u32, *data);
    c := get(u32, *data);

    if b > a  part1 += 1;
    if c > b  part1 += 1;

    while data.count
    {
        d := get(u32, *data);

        if d > c  part1 += 1;
        if d > a  part2 += 1;

        a, b, c = b, c, d;
    }

    return tprint("%", part1), tprint("%", part2);
}