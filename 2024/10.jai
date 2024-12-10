day10 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        i := y*(SIZE+1) + x;
        part1 += ifx input[i] == #char "0" walk(input, x, y);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

dirs :: []s64.[.[-1,0], .[1,0], .[0,-1], .[0,1]];
SIZE :: 50;

walk :: (map: string, x: s64, y: s64) -> s64
{
    result := 0;
    i := y*(SIZE+1) + x;

    for dirs
    {
        nx, ny := x+it[0], y+it[1];
        if nx < 0 continue;
        if ny < 0 continue;
        if nx >= SIZE continue;
        if ny >= SIZE continue;
        ni := ny*(SIZE+1) + nx;
        if map[i] + 1 != map[ni] continue;
        result += ifx map[ni] == #char "9" then 1 else walk(map, nx, ny);
    }

    return result;
}


/*

1242 too high

89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732

36

*/