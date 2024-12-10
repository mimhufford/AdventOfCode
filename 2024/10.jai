day10 :: (input: string) -> string, string
{
    part1, part2 := 0;

    for y: 0..SIZE-1 for x: 0..SIZE-1
    {
        i := y*(SIZE+1) + x;
        part1 += ifx input[i] == #char "0" walk_unique(input, x, y);
        part2 += ifx input[i] == #char "0" walk_combos(input, x, y);
    }

    return tprint("%", part1), tprint("%", part2);
}

#scope_file

dirs :: []s64.[.[-1,0], .[1,0], .[0,-1], .[0,1]];
SIZE :: 50;

walk_unique :: (map: string, x: s64, y: s64) -> s64
{
    walk :: (map: string, x: s64, y: s64, result: *[..]s64)
    {
        for dirs
        {
            nx, ny := x+it[0], y+it[1];
            if nx < 0 continue;
            if ny < 0 continue;
            if nx >= SIZE continue;
            if ny >= SIZE continue;
            ci :=  y*(SIZE+1) +  x;
            ni := ny*(SIZE+1) + nx;
            if map[ci] + 1 != map[ni] continue;
            if map[ni] == #char "9" array_add_if_unique(result, ni);
            else walk(map, nx, ny, result);
        }
    }

    result : [..]s64;
    walk(map, x, y, *result);
    return result.count;
}

walk_combos :: (map: string, x: s64, y: s64) -> s64
{
    result := 0;

    for dirs
    {
        nx, ny := x+it[0], y+it[1];
        if nx < 0 continue;
        if ny < 0 continue;
        if nx >= SIZE continue;
        if ny >= SIZE continue;
        ci :=  y*(SIZE+1) +  x;
        ni := ny*(SIZE+1) + nx;
        if map[ci] + 1 != map[ni] continue;
        if map[ni] == #char "9" result += 1;
        else result += walk_combos(map, nx, ny);
    }

    return result;
}