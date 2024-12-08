day8 :: (input: string) -> string, string
{
    antennas  : [256][..]struct{ x, y: s64; };
    antinodes : [2][SIZE][SIZE]bool;

    part1, part2 := 0;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        i := y*(SIZE+1) + x;
        if input[i] == #char "." continue;
        if !antinodes[1][y][x]
        {
            antinodes[1][y][x] = true;
            part2 += 1;
        }

        for antennas[input[i]]
        {
            dx, dy := it.x - x, it.y - y;
            
            x1, y1 := it.x + dx, it.y + dy;
            if x1 >= 0 && x1 < SIZE && y1 >= 0 && y1 < SIZE && !antinodes[0][y1][x1]
            {
                antinodes[0][y1][x1] = true;
                part1 += 1;
            }
            while true
            {
                if x1 >= 0 && x1 < SIZE && y1 >= 0 && y1 < SIZE
                {
                    if !antinodes[1][y1][x1]
                    {
                        antinodes[1][y1][x1] = true;
                        part2 += 1;
                    }
                    x1, y1 += dx, dy;
                }
                else
                {
                    break;
                }
            }

            x2, y2 := x - dx, y - dy;
            if x2 >= 0 && x2 < SIZE && y2 >= 0 && y2 < SIZE && !antinodes[0][y2][x2]
            {
                antinodes[0][y2][x2] = true;
                part1 += 1;
            }
            while true
            {
                if x2 >= 0 && x2 < SIZE && y2 >= 0 && y2 < SIZE
                {
                    if !antinodes[1][y2][x2]
                    {
                        antinodes[1][y2][x2] = true;
                        part2 += 1;
                    }
                    x2, y2 -= dx, dy;
                }
                else
                {
                    break;
                }
            }
        }
        array_add(*antennas[input[i]], .{ x, y });
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

SIZE :: 50;