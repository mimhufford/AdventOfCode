day23 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    walk1(map, 1, 0, 0, 1);
    walk2(map, 1, 0, 0, 1);

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

part1, part2 := 0;

walk2 :: (map: []string, _x: s64, _y: s64, _dx: s64, _dy: s64)
{
    visited : [..]u64;
    walk2(map, _x, _y, _dx, _dy, 0, visited);
}

// TODO: collapse the graph down
// TODO: merge walk1 and walk2

walk2 :: (map: []string, _x: s64, _y: s64, _dx: s64, _dy: s64, _steps: s64, _visited: []u64)
{
    x, y, dx, dy, steps := _x, _y, _dx, _dy, _steps;
    visited : [..]u64; array_copy(*visited, _visited);

    while true
    {
        options : [..]Direction;

        for d: Direction.[.{-1, 0}, .{1, 0}, .{0, -1}, .{0, 1}]
        {
            // don't backtrack
            if d.dx == -dx && d.dy == -dy continue;

            // wall
            if map[y+d.dy][x+d.dx] == #char "#" continue;

            array_add(*options, d);
        }

        if options.count == 1
        {
            next := ((cast(u64)(x+options[0].dx)) << 32) | (cast(u64)(y+options[0].dy));
            if array_find(visited, next) break;
            
            x += options[0].dx;
            y += options[0].dy;
            dx = options[0].dx;
            dy = options[0].dy;
            steps += 1;

            if y == map.count - 1
            {
                if part2 < steps print("%\n", steps);
                part2 = max(part2, steps);
                break;
            }
        }
        else
        {
            curr := ((cast(u64)(x)) << 32) | (cast(u64)(y));
            array_add(*visited, curr);

            for options
            {
                next := ((cast(u64)(x+it.dx)) << 32) | (cast(u64)(y+it.dy));
                if array_find(visited, next) continue;
                array_add(*visited, next);
                walk2(map, x+it.dx, y+it.dy, it.dx, it.dy, steps+1, visited);
            }
            break;
        }
    }
}

walk1 :: (map: []string, _x: s64, _y: s64, _dx: s64, _dy: s64, _steps := 0)
{
    x, y, dx, dy, steps := _x, _y, _dx, _dy, _steps;

    while true
    {
        options : [..]Direction;

        for d: Direction.[.{-1, 0}, .{1, 0}, .{0, -1}, .{0, 1}]
        {
            // don't backtrack
            if d.dx == -dx && d.dy == -dy continue;

            // wall
            if map[y+d.dy][x+d.dx] == #char "#" continue;

            // trying to go left onto a >
            if map[y+d.dy][x+d.dx] == #char ">" && d.dx == -1 continue;

            // trying to go right onto a <
            if map[y+d.dy][x+d.dx] == #char "<" && d.dx == 1 continue;

            // trying to go down onto a ^
            if map[y+d.dy][x+d.dx] == #char "^" && d.dy == 1 continue;

            // trying to go up onto a v
            if map[y+d.dy][x+d.dx] == #char "v" && d.dy == -1 continue;

            array_add(*options, d);
        }

        if options.count == 1
        {
            x += options[0].dx;
            y += options[0].dy;
            dx = options[0].dx;
            dy = options[0].dy;
            steps += 1;

            if y == map.count - 1
            {
                part1 = max(part1, steps);
                break;
            }
        }
        else
        {
            for options walk1(map, x+it.dx, y+it.dy, it.dx, it.dy, steps+1);
            break;
        }
    }
}

Direction :: struct
{
    dx, dy: s8;
}