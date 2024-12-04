day4 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for y: 0..SIZE-1
    {
        for x: 0..SIZE-1
        {
            part1, part2 += check(input, x, y);
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 140;

check :: (s: string, x: s64, y: s64) -> s64, s64
{
    index := y * (SIZE+1) + x;
    xmas, x_mas := 0;

    xmas_match :: (offset: s64) -> bool #expand
    {
        word : [4]u8;
        for 0..3 word[it] = s[index + it*offset];
        return cast(string)word == "XMAS" || cast(string)word == "SAMX";
    }

    if x <= SIZE-4 &&                xmas_match(1)        then xmas += 1;
    if                y <= SIZE-4 && xmas_match(SIZE + 1) then xmas += 1;
    if x <= SIZE-4 && y <= SIZE-4 && xmas_match(SIZE + 2) then xmas += 1;
    if x >= 3      && y <= SIZE-4 && xmas_match(SIZE)     then xmas += 1;

    x_mas_match :: (offset: s64) -> bool #expand
    {
        word : [3]u8;
        for -1..1 word[it+1] = s[index + it*offset];
        return cast(string)word == "MAS" || cast(string)word == "SAM";
    }

    if x >= 1 && x < SIZE-1 && y >= 1 && y < SIZE-1 && x_mas_match(SIZE+2) && x_mas_match(SIZE) then x_mas += 1;

    return xmas, x_mas;
}