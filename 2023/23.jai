day23 :: (input: string) -> string, string
{
    map := split(trim(input), "\n");

    walk(map, 1, 0, 0, 1);

    return tprint("%", part1), "";
}

#scope_file

part1 := 0;

walk :: (map: []string, x: s64, y: s64, dx: s64, dy: s64, steps := 0)
{
    for dir: [2]s64.[.[-1, 0], .[1, 0], .[0, -1], .[0, 1]]
    {
        // don't backtrack
        if dir[0] == -dx && dir[1] == -dy continue;

        // finished
        if y == map.count-1
        {
            if part1 < steps
            {
                // print("%\n", steps);
                part1 = steps;
            }
            continue;
        }

        // wall
        if map[y+dy][x+dx] == #char "#" continue;

        // trying to go left onto a >
        if map[y+dy][x+dx] == #char ">" && dir[0] == -1 continue;

        // trying to go right onto a <
        if map[y+dy][x+dx] == #char "<" && dir[0] == 1 continue;

        // trying to go down onto a ^
        if map[y+dy][x+dx] == #char "^" && dir[1] == 1 continue;

        // trying to go up onto a v
        if map[y+dy][x+dx] == #char "v" && dir[0] == -1 continue;

        // recurse
        walk(map, x+dx, y+dy, dir[0], dir[1], steps + 1);
    }
}