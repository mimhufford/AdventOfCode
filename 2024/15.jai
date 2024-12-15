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

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        if map[y][x] == #char "O"
        {
            part1 += 100*y + x;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 50;

move :: (map: *[SIZE][SIZE]u8, rx: *s64, ry: *s64, dx: s64, dy: s64)
{
    // walk until we hit and wall or a gap
    gap := false;
    x, y := rx.*, ry.*;
    while true
    {
        x, y += dx, dy;
        if map.*[y][x] == #char "." { gap = true; break; }
        if map.*[y][x] == #char "#" { break; }
    }

    // if there was no gap there's nothing to do
    if !gap return;

    // there was a gap, so move everything along
    x, y -= dx, dy;
    while true
    {
        if x == rx.* && y == ry.* break;
        map.*[y][x] = map.*[y-dy][x-dx];
        x, y -= dx, dy;
    }
}