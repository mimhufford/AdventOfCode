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

    part1 := walk(map, sx, sy);

    return tprint("%", part1), tprint("%", 0);
}

#scope_file

walk :: (map: []string, sx: s64, sy: s64) -> s64
{
    x := sx;
    y := sy;
    dir := Direction.N; // TODO: work out direction

    steps := 1;
    step(map, *x, *y, *dir);

    while x != sx || y != sy
    {
        steps += 1;
        step(map, *x, *y, *dir);
    }

    return steps / 2;
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