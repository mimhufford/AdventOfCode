day10 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    sx, sy := 0;

    for y: 0..map.count-1
    {
        for x: 0..map[y].count-1
        {
            if map[y][x] == #char "S"
            {
                sx = x;
                sy = y;
                break;
            }
        }
    }

    loop := walk(map, sx, sy);
    part1 := loop.count / 2;

    // blank out all the cells not on the loop
    for y: 0..map.count-1
    {
        for x: 0..map[y].count-1
        {
            if !table_contains(*loop, y << 32 | x) map[y][x] = #char " ";
        }
    }

    part2 := 0;
    for y: 0..map.count-1
    {
        inside := false;

        for x: 0..map[y].count-1
        {
            c := map[y][x];
            if c == #char "|" || c == #char "L" || c == #char "J" inside = !inside;
            if inside && c == #char " " part2 += 1;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

walk :: (map: []string, sx: s64, sy: s64) -> Table(s64, *void)
{
    x, y := sx, sy;
    map[y][x] = #char "L"; // TODO: hack
    dir := Direction.N;    // TODO: work out direction

    loop : Table(s64, *void);
    table_add(*loop, y << 32 | x, null);

    step(map, *x, *y, *dir);
    table_add(*loop, y << 32 | x, null);

    while x != sx || y != sy
    {
        step(map, *x, *y, *dir);
        table_add(*loop, y << 32 | x, null);
    }

    return loop;
}

step :: (map: []string, x: *s64, y: *s64, dir: *Direction)
{
    if dir.* ==
    {
        case .N;
        y.* -= 1;
        if      map[y.*][x.*] == #char "|" dir.* = .N;
        else if map[y.*][x.*] == #char "7" dir.* = .W;
        else if map[y.*][x.*] == #char "F" dir.* = .E;

        case .E;
        x.* += 1;
        if      map[y.*][x.*] == #char "-" dir.* = .E;
        else if map[y.*][x.*] == #char "7" dir.* = .S;
        else if map[y.*][x.*] == #char "J" dir.* = .N;

        case .S;
        y.* += 1;
        if      map[y.*][x.*] == #char "|" dir.* = .S;
        else if map[y.*][x.*] == #char "L" dir.* = .E;
        else if map[y.*][x.*] == #char "J" dir.* = .W;

        case .W;
        x.* -= 1;
        if      map[y.*][x.*] == #char "-" dir.* = .W;
        else if map[y.*][x.*] == #char "L" dir.* = .N;
        else if map[y.*][x.*] == #char "F" dir.* = .S;
    }
}

Direction :: enum { N; E; S; W; }