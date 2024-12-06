day6 :: (input: string) -> string, string
{
    part1, part2 : s64;

    map := split(input, "\n");
    map.count -= 1;

    dirs := [2]s64.[
        .[ 0, -1],
        .[ 1,  0],
        .[ 0,  1],
        .[-1,  0],
    ];

    x, y, dir : s64;

    for row, r: map for char, c: row
    {
        if char == #char "^"
        {
            x, y = c, r;
            map[r][c] = #char "X";
            part1 += 1;
            break;
        }
    }

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
        else
        {
            x, y += dx, dy;

            if map[y][x] != #char "X"
            {
                map[y][x] = #char "X";
                part1 += 1;
            }
        }
    }

    return tprint("%", part1), tprint("%", part2);
}