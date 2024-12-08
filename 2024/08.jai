day8 :: (input: string) -> string, string
{
    SIZE :: 50;
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

            handle_line :: (x: s64, y: s64, dx: s64, dy: s64) #expand
            {
                for 0..S64_MAX
                {
                    x, y += dx, dy;

                    if x < 0 || x >= SIZE || y < 0 || y >= SIZE break;

                    if it == 0 && !antinodes[0][y][x]
                    {
                        antinodes[0][y][x] = true;
                        part1 += 1;
                    }

                    if !antinodes[1][y][x]
                    {
                        antinodes[1][y][x] = true;
                        part2 += 1;
                    }
                }
            }
            
            handle_line(it.x, it.y, +dx, +dy);
            handle_line(   x,    y, -dx, -dy);
        }

        array_add(*antennas[input[i]], .{ x, y });
    }

    return tprint("%", part1), tprint("%", part2);
}