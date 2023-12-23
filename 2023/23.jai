day23 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    walk(map, 1, 0, 0, 1);

    return tprint("%", part1), tprint("%", 0);
}

#scope_file

part1 := 0;

walk :: (map: []string, _x: s64, _y: s64, _dx: s64, _dy: s64, _steps := 0)
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
            for options walk(map, x+it.dx, y+it.dy, it.dx, it.dy, steps+1);
            break;
        }
    }
}

Direction :: struct
{
    dx, dy: s8;
}