day6 :: (input: string) -> string, string
{
    map := split(tprint("%", input), "\n");
    map.count -= 1;

    for row, r: map for char, c: row
    {
        if char == #char "^"
        {
            start_x, start_y = c, r;
            break;
        }
    }

    _, part1 := walk(map);

    part2 : s64;
    changed_map := split(input, "\n");
    changed_map.count -= 1;

    for r: 0..map.count-1 for c: 0..map[0].count-1
    {
        if r == start_y && c == start_x continue;
        if map[r][c] == #char "#" continue;
        if map[r][c] == #char "." continue;

        // reset the changed map
        for * char: input
        {
            if char.* == #char "#" continue;
            if char.* == #char "." continue;
            char.* = #char ".";
        }

        changed_map[r][c] = #char "#"; // add the new obstacle

        if walk(changed_map) part2 += 1;

        changed_map[r][c] = #char "."; // remove it ready for next time
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

start_x, start_y : s64;
dir_chars :: "^>V<";
dirs      :: []s64.[ .[0, -1], .[1, 0], .[0, 1], .[-1, 0] ];

walk :: (map: []string) -> bool, s64
{
    x, y, dir, visited := start_x, start_y, 0, 1;

    while true
    {
        dx, dy := dirs[dir][0], dirs[dir][1];

        if x+dx < 0             break;
        if y+dy < 0             break;
        if x+dx >= map[0].count break;
        if y+dy >= map.count    break;

        if map[y+dy][x+dx] == #char "#"
        {
            dir = (dir+1) % 4;
        }
        else if map[y+dy][x+dx] == dir_chars[dir]
        {
            return true, 0;
        }
        else
        {
            x, y += dx, dy;

            if map[y][x] == #char "."
            {
                map[y][x] = dir_chars[dir];
                visited += 1;
            }
        }
    }

    return false, visited;
}