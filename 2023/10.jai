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
    dx, dy := 0, -1;       // TODO: work out direction
    map[y][x] = #char "L"; // TODO: hack

    loop : Table(s64, *void);
    table_add(*loop, y << 32 | x, null);

    while true
    {
        x += dx; y += dy;
        dx, dy = step(map, x, y, dx, dy);
        table_add(*loop, y << 32 | x, null);
        if x == sx && y == sy break;
    }

    return loop;
}

step :: (map: []string, x: s64, y: s64, dx: s64, dy: s64) -> s64, s64
{
    if dy == -1 && map[y][x] == #char "|" return  0, -1;
    if dy == -1 && map[y][x] == #char "7" return -1,  0;
    if dy == -1 && map[y][x] == #char "F" return  1,  0;
    if dy ==  1 && map[y][x] == #char "|" return  0,  1;
    if dy ==  1 && map[y][x] == #char "L" return  1,  0;
    if dy ==  1 && map[y][x] == #char "J" return -1,  0;
    if dx == -1 && map[y][x] == #char "-" return -1,  0;
    if dx == -1 && map[y][x] == #char "L" return  0, -1;
    if dx == -1 && map[y][x] == #char "F" return  0,  1;
    if dx ==  1 && map[y][x] == #char "-" return  1,  0;
    if dx ==  1 && map[y][x] == #char "7" return  0,  1;
    if dx ==  1 && map[y][x] == #char "J" return  0, -1;

    return 0, 0;
}