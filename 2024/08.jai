day8 :: (input: string) -> string, string
{
    antennas  : [256][..]struct{ x, y: s64; };
    antinodes : [SIZE][SIZE]bool;

    part1, part2 := 0;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        i := y*(SIZE+1) + x;
        if input[i] == #char "." continue;
        for antennas[input[i]]
        {
            dx, dy := it.x -  x, it.y -  y;
            x1, y1 := it.x - dx, it.y - dy;
            x2, y2 :=    x + dx,    y + dy;
            if x1 >= 0 && x1 < SIZE && y1 >= 0 && y1 < SIZE && !antinodes[y1][x1]
            {
                antinodes[y1][x1] = true;
                part1 += 1;
            }
            if x2 >= 0 && x2 < SIZE && y2 >= 0 && y2 < SIZE && !antinodes[y2][x2]
            {
                antinodes[y2][x2] = true;
                part1 += 1;
            }
        }
        array_add(*antennas[input[i]], .{ x, y });
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 50;