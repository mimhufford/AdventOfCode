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

    match :: (offset: s64) -> bool #expand
    {
        word : [4]u8;
        for 0..3 word[it] = s[index + it*offset];
        return cast(string)word == "XMAS" || cast(string)word == "SAMX";
    }

    if x <= SIZE-4 &&                match(1)        then xmas += 1;
    if                y <= SIZE-4 && match(SIZE + 1) then xmas += 1;
    if x <= SIZE-4 && y <= SIZE-4 && match(SIZE + 2) then xmas += 1;
    if x >= 3      && y <= SIZE-4 && match(SIZE)     then xmas += 1;

    if x >= 1 && x < SIZE-1 && y >= 1 && y < SIZE-1
    {
        a : [3]u8;
        a[0] = s[index - SIZE - 2];
        a[1] = s[index];
        a[2] = s[index + SIZE + 2];

        b : [3]u8;
        b[0] = s[index - SIZE];
        b[1] = s[index];
        b[2] = s[index + SIZE];

        if (cast(string)a == "MAS" || cast(string)a == "SAM") &&
           (cast(string)b == "MAS" || cast(string)b == "SAM")
        {
            x_mas += 1;
        }
    }

    return xmas, x_mas;
}