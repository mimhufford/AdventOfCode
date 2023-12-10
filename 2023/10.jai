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
    walkers : [2]Walker;
    walkers[0].x = sx;
    walkers[0].y = sy;
    walkers[1].x = sx;
    walkers[1].y = sy;

    // TODO: work out directions programmatically
    walkers[0].dir = .N;
    walkers[1].dir = .E;

    steps := 1;
    step(map, *walkers[0]);
    step(map, *walkers[1]);

    while walkers[0].x != walkers[1].x || walkers[0].y != walkers[1].y
    {
        steps += 1;
        step(map, *walkers[0]);
        step(map, *walkers[1]);
    }

    return steps;
}

step :: (map: []string, w: *Walker)
{
    if w.dir ==
    {
        case .N;
        w.y -= 1;
        if      map[w.y][w.x] == #char "|" w.dir = .N;
        else if map[w.y][w.x] == #char "7" w.dir = .W;
        else if map[w.y][w.x] == #char "F" w.dir = .E;

        case .E;
        w.x += 1;
        if      map[w.y][w.x] == #char "-" w.dir = .E;
        else if map[w.y][w.x] == #char "7" w.dir = .S;
        else if map[w.y][w.x] == #char "J" w.dir = .N;

        case .S;
        w.y += 1;
        if      map[w.y][w.x] == #char "|" w.dir = .S;
        else if map[w.y][w.x] == #char "L" w.dir = .E;
        else if map[w.y][w.x] == #char "J" w.dir = .W;

        case .W;
        w.x -= 1;
        if      map[w.y][w.x] == #char "-" w.dir = .W;
        else if map[w.y][w.x] == #char "L" w.dir = .N;
        else if map[w.y][w.x] == #char "F" w.dir = .S;
    }
}

Walker :: struct
{
    x, y : s64;
    dir  : Direction;
}

Direction :: enum { N; E; S; W; }