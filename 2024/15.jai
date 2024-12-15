day15 :: (input: string) -> string, string
{
    map : [SIZE][SIZE]u8;
    x, y := 0;

    for my: 0..SIZE-1
    {
        for mx: 0..SIZE-1
        {
            if input[0] == #char "@"
            {
                x, y = mx, my;
                map[my][mx] = #char ".";
            }
            else
            {
                map[my][mx] = input[0];
            }

            advance(*input);
        }

        advance(*input);
    }

    while input
    {
        if input[0] ==
        {
            case #char "<"; move(*map, *x, *y, -1, +0);
            case #char ">"; move(*map, *x, *y, +1, +0);
            case #char "^"; move(*map, *x, *y, +0, -1);
            case #char "v"; move(*map, *x, *y, +0, +1);
        }

        advance(*input);
    }

    part1, part2 := 0;

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 50;

move :: (map: *[SIZE][SIZE]u8, x: *s64, y: *s64, dx: s64, dy: s64)
{

}