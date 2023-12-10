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
                map[y][x] = #char "L"; // TODO: hack
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
            // TODO: slow
            overwrite := true;
            for loop
            {
                if it.x == x && it.y == y
                {
                    overwrite = false;
                    break;
                }
            }
            if overwrite map[y][x] = #char " ";
        }
    }

    part2 := 0;
    for y: 0..map.count-1
    {
        inside := false;

        for x: 0..map[y].count-1
        {
            c := map[y][x];
            if      c == #char "|" { inside = !inside; continue; }
            else if c == #char "L" { inside = !inside; continue; }
            else if c == #char "J" { inside = !inside; continue; }

            if inside && c == #char " " part2 += 1;
        }
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

walk :: (map: []string, sx: s64, sy: s64) -> []Point
{
    x, y := sx, sy;
    dir := Direction.N; // TODO: work out direction

    loop : [..]Point;

    p := array_add(*loop);
    p.x, p.y = x, y;

    step(map, *x, *y, *dir);
    p = array_add(*loop);
    p.x, p.y = x, y;

    while x != sx || y != sy
    {
        step(map, *x, *y, *dir);
        p = array_add(*loop);
        p.x, p.y = x, y;
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

Point :: struct
{
    x, y: s64;
}

Direction :: enum { N; E; S; W; }