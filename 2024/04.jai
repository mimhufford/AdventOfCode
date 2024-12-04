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

    if x <= SIZE-4
    {
        horz := slice(s, index, 4);
        if horz == "XMAS" || horz == "SAMX" xmas += 1;
    }

    if y <= SIZE-4
    {
        vert : [4]u8;
        vert[0] = s[index + 0*(SIZE+1)];
        vert[1] = s[index + 1*(SIZE+1)];
        vert[2] = s[index + 2*(SIZE+1)];
        vert[3] = s[index + 3*(SIZE+1)];
        if cast(string)vert == "XMAS" || cast(string)vert == "SAMX" xmas += 1;
    }

    if x <= SIZE-4 && y <= SIZE-4
    {
        diag : [4]u8;
        diag[0] = s[index + 0*(SIZE+2)];
        diag[1] = s[index + 1*(SIZE+2)];
        diag[2] = s[index + 2*(SIZE+2)];
        diag[3] = s[index + 3*(SIZE+2)];
        if cast(string)diag == "XMAS" || cast(string)diag == "SAMX" xmas += 1;
    }

    if x >= 3 && y <= SIZE-4
    {
        diag : [4]u8;
        diag[0] = s[index + 0*SIZE];
        diag[1] = s[index + 1*SIZE];
        diag[2] = s[index + 2*SIZE];
        diag[3] = s[index + 3*SIZE];
        if cast(string)diag == "XMAS" || cast(string)diag == "SAMX" xmas += 1;
    }

    return xmas, x_mas;
}